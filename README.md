
          
From Lua to LLVM
================

Background
----------

This page shows the implementation of a compiler that recognizes and translates part of the Lua programming language into the LLVM IR syntax (more information about LLVM can be found [here](https://www.skenz.it/compilers/llvm "https://www.skenz.it/compilers/llvm")).

The LLVM Intermediate Representation (IR) is placed between the source code in a given programming language and the machine code for a specific architecture. It is independent of both the programming language and the architecture.

Lua language
------------

Many resources are available if you want to learn Lua. Following, you can find a few of them.

*   [Programming in Lua](https://www.lua.org/pil/contents.html "https://www.lua.org/pil/contents.html") - Online version of the first edition of the book Programming in Lua, a detailed and authoritative introduction to all aspects of Lua programming written by Lua's chief architect. It is an entire book, so it is advised to all those who want to fully learn and understand Lua.
    

*   [Lua tutorial](https://www.tutorialspoint.com/lua/lua_functions.html "https://www.tutorialspoint.com/lua/lua_functions.html") - Lua tutorial. It is advised to all those who want to quickly learn Lua, without going too in depth in the language.
    

*   [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/ "https://www.lua.org/manual/5.4/") - The reference manual is the official definition of the Lua language.
    

Compiler
========

The compiler is made up of two parts: a scanner and a parser.

Scanner
-------

The scanner has been written using jFlex. It performs lexical analysis, i.e. converts a sequence of bytes into a sequence of tokens. It recognizes the most important Lua source code symbols and generates tokens later used by the parser. The one implemented here can tokenize multiple files. This last feature allows the implementation of `require` keyword functionality of Lua: multiple files are compiled (statically) into a single LLVM IR syntax program.

### Snippet of Lua scanner

  ```lex
   ...
 
id = [A-Za-z_][A-Za-z0-9_]*
number = ([1-9][0-9]*|0) | (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?
string = \"~\"
nl = \r|\n|\r\n|" "
n2 = \r|\n|\r\n
comment = "--"~{n2}|"--[["~"--]]"
FILE = \"[A-Za-z_][A-Za-z0-9_\.]*\"
%%
 
{comment} { ; }  
 
"require" {        
                    yybegin(INCL); 
                    return symbol(sym.REQUIRE);
          }
 
<INCL>[\ \t]+ {;}
 
<INCL>{FILE} {
  String file = yytext().substring(1, yytext().length()-1);
   Path path
            = Paths.get("./" +
               file);
 
  if (!Files.isReadable(path)){
     System.out.println("File " +path + " does not exists ");
     System.exit(-1);
     return symbol(sym.FNF);
  }
 
    try{
    yypushStream(new FileReader(file.trim()));
    yybegin(YYINITIAL);
    return symbol(sym.FILE, file.substring(0, file.length()-4));
    }catch(Exception e){
 
      return symbol(sym.FNF);
 
    }
}
 
<DELETENR>[\t\n\r]+ {yybegin(YYINITIAL);}
 
<<EOF>> {
 
      if(yymoreStreams()){
          yypopStream();
          yybegin(DELETENR);
          parser.libraryName="";
      }else return symbol(sym.EOF);
}
 
 
"string.format"   {return symbol(sym.STRFRT);}
"do"              {return symbol(sym.DO);}
"for"             {return symbol(sym.FOR);}
"if"              {return symbol(sym.IF);}
"else"            {return symbol(sym.ELSE);}
 
"end"             {return symbol(sym.END);}
"local"           {return symbol(sym.LOCAL);}
 
"nil"             {return symbol(sym.NIL);}
"print"           {return symbol(sym.PRINT);}
"return"          {return symbol(sym.RETURN);}
"function"        {return symbol(sym.FUNCTION);}
"then"            {return symbol(sym.THEN);}
"while"           {return symbol(sym.WHILE);}
"until"           {return symbol(sym.UNTIL);}
"repeat"          {return symbol(sym.REPEAT);}
 
"("               {return symbol(sym.RO);}
")"               {return symbol(sym.RC);}
"{"               {return symbol(sym.BO);}
...
"not"             {return symbol(sym.NOT);}
"^"               {return symbol(sym.HAT);}
"~="              {return symbol(sym.NOTEQ);}
"["               {return symbol(sym.SO);}
"]"               {return symbol(sym.SC);}
","               {return symbol(sym.CM);}
 
 
{id}\.{id}        {return symbol(sym.ID, yytext());}
{id}              {return symbol(sym.ID, yytext());}
{string}          {return symbol(sym.STRING, yytext());}
{number}          {return symbol(sym.NUMBER, Double.valueOf(yytext()));}
 
 
{nl} {;}
 
. {System.out.println("SCANNER ERROR: "+yytext());}
  ```

The snippet above contains the most important part of the scanner code. Grammar rules occupy most of it: they are the key ingredient to transform a sequence of input bytes into a token. For example, the rule at line 89 allows recognizing a Lua number and giving the parser a symbol of type NUMBER with its numeric value attached.

In order to scan and parse multiple files, states must be used. The symbol `<:STATE>` before some grammar rules allow to activate them only when the scanner is in the state `STATE`. In particular, when the `require` keyword is recognized (line 14), the instruction `yybegin(“INCL”)` allows changing the state of the scanner to the state `INCL`. In this way, the two following rules are activated and a sequence of operations are performed in order to switch from the current file to the one specified after the keyword `require` (get the file name, open it, push it on the stack of the file…). Similarly, when the `EOF` is reached, the current file is popped from the file stack and the scanner is put in a different state (`DELETENR`) to restart the scan of the original file.

Parser
------

The parser performs the syntactical analysis. It asks the scanner for tokens and recognizes the main grammar rules of Lua language. When a sequence of symbols is reduced, an action is performed. This allows generating LLVM IR code from Lua source code, as well as performing some semantic analysis.

**_Note:_**

Throughout this parser, intermediate actions are present in the rhs of rules. It is worth to remember that if we want to put an action in the middle of the rhs of a rule in a bottom-up parser, we use a dummy nonterminal, called a marker. For example,

 ```cup

X ::= a { action } b

is equivalent to

X ::= M b

M ::= a { action }

```

_This is done automatically by the CUP parser generator_ (i.e., we can actually put actions in the middle of a rhs of a rule and CUP will use the above trick to put it at the end of a rule). There is a danger though that the resulting rules may introduce new shift/reduce or reduce/reduce conflicts.

### Output structure

Before diving into the translation from Lua source code to LLVM IR and all the support data structures used by the parser, let us understand the global picture. The following is an LLVM IR code translated with this parser (and the related scanner).

 ```cup
@.str.0 = private constant [6 x i8] c"%.0f \00", align 1
@.str.1 = private constant [2 x i8] c"\0A\00", align 1
 
@a = global double 0.0, align 8
@l = global double 20.0, align 8
@i = global double 0.0, align 8
@k = global double 0.0, align 8
 
define double @Math.pow(double, double ) {
....
}
 
 
define void @main(){
store double 0.0, double* @a, align 8
store double 20.0, double* @l, align 8
store double 0.0, double* @i, align 8
br label %for.cond.1
for.cond.1:
%1 = load double, double* @i, align 8
%2 = load double, double* @l, align 8
%3 = fcmp ole double %1, %2
...
br label %for.inc.1
for.exit.1:
ret void
}    
```
It is clear, looking at the code, that it is divided into three sections:

*   constant string declarations
    
*   global variables declarations and functions
    
*   main function
    

In order to achieve this organization of the code, three StringBuffer are used throughout the parser:

*   `stringDecl` (used for constant string declarations)
    
*   `globalDecBuffer` (used for global variables declarations)
    
*   `funcBuffer` (used for functions)
    

To simplify the append operation, wrapper functions are defined. They allow to append something and choose if go to a new line or not.

The following wrapper functions are defiend:

```cup

    public void appendFuncBuffer(String s, boolean newLine) {
      funcBuffer.append(s);
      if (newLine)
        funcBuffer.append("\n");
    }
 
    public void appendGlobalDecBuffer(String s, boolean newLine) {
      globalDecBuffer.append(s);
      if (newLine)
        globalDecBuffer.append("\n");
    }
 
    public void appendMainBuffer(String s, boolean newLine) {
      currentSymTable.currentBuffer.append(s);
      if (newLine)
        currentSymTable.currentBuffer.append("\n");
    }
    
 ```  
    

### Grammar start

When an LLVM IR instruction must be generated after a reduction, it is appended to the proper buffer. When the start symbol is reduced (meaning that the code has been parsed correctly), the actions performed consist of printing the `StringBuffer`s in the proper order, so as to achieved the above mentioned code structure.

```cup
prog ::= stmt_list  {:
                      printStrings();
                      bwr.write(stringDecl.toString()+"\n");
                      bwr.write(globalDecBuffer.toString()+"\n");
                      bwr.write(funcBuffer.toString()+"\n");
                      bwr.write("define void @main(){\n");
                      bwr.write(mainBuffer.toString());
                      bwr.write("ret void\n}");
                      bwr.flush();
                      //close the stream
                      bwr.close();
	                  :}
;
 ```      

### Symbol table

The symbol table is a core data structure in all parsers, and in this one too. Inside of it, numerous data collections can be found, used for different purposes. Comments in the below code help understand the need and use of them. One of the main features that are possible thanks to this structure, is the local scoping.

The constructor at line 32 allows chaining many symbol tables while going deep down in nested statements. It takes as input the previous symbol table and a flag used to distinguish if we are entering a function or not. In the latter case, the code from line 52 to line 58 is executed, allowing to set the `currentBuffer` to `funcBuffer`. Also, it is worth noticing that when entering a function, the register number must restart from 1.

```cup
 public class SymbolTable {
    /* Used in multiple assignment */
    public ArrayList<ValueObj> varList;
    /* Used in multiple assignment */
    public ArrayList<ValueObj> expList;
    /* Actual Symbol table storing NAME : VALUE */
    public HashMap<String, ValueObj> varTable;
    /* Counter of llvm registers */
    public Integer registerCount; // used as counter for SSA registers
    /* reference to previous symbol table - used in local scopes */
    SymbolTable prev;
    /* stores the current buffer to append to */
    StringBuffer currentBuffer;
    /* 
     *boolean storing if we are in a function or not
     * needed to distinguish local scopes due to blocks from functions
     */
    boolean isFunc;
 
    public SymbolTable getPrev(boolean insideSameFunction) {
      if (insideSameFunction) {
        prev.registerCount = registerCount;
        return prev;
      } else {
        return prev;
      }
    }
 
    /*
     * isFunction is needed to distinguish local scopes due to blocks from functions
     */
    public SymbolTable(SymbolTable p, boolean isFunction) { 
      this.varTable = new HashMap<String, ValueObj>();
      this.varList = new ArrayList<ValueObj>();
      this.expList = new ArrayList<ValueObj>();
      this.prev = p;
 
      /*
       * when starting parsing, register counter start from 1
       * when entering a local scope, continue with previous counter
       */
 
      this.registerCount = p == null ? 1 : p.registerCount; 
 
      /*
       * when starting parsing, set current buffer to main buffer
       * when entering a local scope, continue with previous buffer
       */
 
      currentBuffer = p == null ? currentBuffer : p.currentBuffer; 
      isFunc=false;
      if (isFunction) {
        /* if it is a funct, restart from 1 */
        registerCount = 1; 
        /* as it is a func, use func buffer */
        currentBuffer = funcBuffer; 
        isFunc=true;
      }
    }
 
    public ValueObj get(String s) {
      /*
       * Given an id, look for it in the current symbol table
       * and in all the ones above
       */
 
 
      for (SymbolTable sym = this; sym != null; sym = sym.prev) {
        ValueObj found = sym.varTable.get(s);
        if (found != null)
          return found;
      }
      return null;
    }
  }
```     

### Function declaration

The following code is used by the parser to recognize function declarations.

```cup
function_decl ::= FUNCTION {: currentSymTable = new SymbolTable(currentSymTable, true); //use new symbol table
                              currentSymTable.currentBuffer=funcBuffer; //set buffer to func buffer                              
                 :}ID:fName RO func_decl_param RC {:
                    if(!libraryName.isBlank()){  //to account for module functions
                         fName=libraryName+"."+fName;
                    }
 
                    if(funcTable.containsKey(fName)){
                        pSemError("FUNCTION ALREADY DECLARED");
                    }
                    FuncObj func = new FuncObj(fName); //create new funct object
                    funcTable.put(fName, func);
                    func.nargsTot=currentSymTable.varList.size(); //set number of param in the function
 
                    appendMainBuffer(("define double @" + fName + "("), false); //definition of function
 
                    for (int i = 0; i < currentSymTable.varList.size(); i++){ //loop through all parameters and append it to the function delcaration
                        if(i!=currentSymTable.varList.size()-1)
                            appendMainBuffer("double, ", false);
                        else
                            appendMainBuffer("double ", false);
                    }
 
                    appendMainBuffer((") {"), true); //end  function declaration
 
                     currentSymTable.registerCount = func.nargsTot + 1;
 
 
 
                    for (int i = 0; i < currentSymTable.varList.size(); i++){ //inside the function, allocate a value for each parameter
                        String reg = getRegister();
                        ValueObj tmp = new ValueObj(reg); //create new value parameter
                        tmp.setDouble();
                        tmp.setLocal();
                        currentSymTable.varTable.put(currentSymTable.varList.get(i).name, tmp); //add to the symbol table
 
                        appendMainBuffer(("%" + reg + " = alloca " + "double" + ", align " + "8"), true); //allocate parameter
                        appendMainBuffer(("store " + "double" + " %" + i + ", "  + "double* " + "%" + reg + ", align 8"), true); //store passed parameter in the function param
                    }
 
                    currentSymTable.varList.clear();  //clear var list
                    :}stmt_list ret END {: appendMainBuffer("\n}", true);  //use directly the regitter
 
                                        currentSymTable = currentSymTable.getPrev(false); currentSymTable.currentBuffer=mainBuffer; //go to previous symbol table e buffer
                                    :}
 
                    | FUNCTION RO func_decl_param RC stmt_list error {: pSynWarning("MISSING RETURN STATEMENT ");:}
                                                        ;
//When entering into a function, it is necessary to switch the StringBuffer --> Need to add stringBuffer in the symbol table
 
 
func_param_list ::= func_param_list:x CM exp:y {: RESULT=x;
                                                    x.add(y);  :} 
                    | exp:y {: RESULT= new ArrayList<ValueObj>();
                                RESULT.add(y);
                                :}| {: RESULT= new ArrayList<ValueObj>();
 
                                :} ;
``` 
In order to understand what it does, let's analyze the following piece of Lua source code from the parser point of view:


```cup
function pow(x, y) 
 ...
end
```  

Upon receiving the token `FUNCTION`, the parser executes the associated action. A new `SymbolTable` is created, which is linked to the previous one (`currentSymTable`) and the flag to signal we are entering in a function is set to true. The current buffer of the new symbol table is set to the functions buffer (the one we have to write to in order to declare functions).

After receiving the name of the function (`ID`) and the list of parameters (`func_decl_param`) (line 3), two checks are performed:

1.  If we are parsing a module added with `require`, the name will be modified accordingly (line 5)
    
2.  If the function has already been declared, a semantic error is thrown (line 9).
    

Then, a `FuncObj` (support data structure for functions) is created and initialized as needed. The function definition (name plus parameters) is appended to the `mainBuffer` (that is `funcBuffer` at the moment). From line 15 to 24 the function declaration is performed. From line 25 to line 41, memory is allocated in the stack for the variables passed as parameters.

After, a token `stmt_list` followed by `ret` is recevied by the parser. `stmt_list` represents the body of the function, and contains any statement accepted by the compiler.

Upon receiving the token `END`, the associated semantic action, consisting of restoring the previous symbol table and the buffer, is perfomed (line 44)

The result has the following structure:

```cup
define double @Math.pow(double, double ) {
 
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
 
//Body of function 
 
ret double %17
 
}
```  
    

### DO END statement

```cup
block ::= DO {: currentSymTable = new SymbolTable(currentSymTable, false);  :}
          stmt_list 
          END {: currentSymTable=currentSymTable.getPrev(true);:};
```  

`DO END` statement allows to create a local scope. To achieve this feature, it is sufficient to create a new symbol table (attached to the previous one).

After receiving the token `DO`, the parser can create the new symbol table (line 1). A sequence of statements can be in the body of `DO END`. After receiving the toke `END`, the parser can close the local scope by restoring the previous symbol table.

### REQUIRE statement

```cup
include ::= REQUIRE FILE:x  {:  libraryName=x; 
                                if(requiredFileList.contains(x)){
                                  pSemError("FILE ALREADY INCLUDED");
                                }
                                requiredFileList.add(x); 
                            :} 
 
                              | REQUIRE FNF {: pSynWarning("REQUIRED FILE NOT FOUND"); :} 
                              | REQUIRE error {: pSynError("REQUIRED FILE NOT SPECIFIED"); :}
;
```  

Almost all of the work needed to implement `REQUIRE` is done by the scanner. The parser has only the job to check that a file with the same name has not already been included. In such a case, a semantic error is raised.

The parser receives the token `REQUIRE`, followed by a`FILE` token (that has the name of the file as an attribute).

The following code contains the supporting data structures:

```cup
   /* Used to construct function names like libraryName.functionName
    * When not parsing a library, the name is "" because we are in the main file
    */
   libraryName = "";
 
   /* List used to keep track of of the libraries already inserted and detect duplicates */
   requiredFileList=new ArrayList<String>();
```    

The `requiredFileList` ArrayList is used to store the name of all files that have been already included.

The `libraryName` variable is used in order to save functions declared inside a file with the name used in their declaration preceded by the name of the file in which they are declared. For example, if the file `Math.lua` contains the function `pow(x, y)`, in order to invoke it, `Math.pow(x, y)` must be written.

### Global declarations-assignements

The following code implements the declaration or assignemnt of 1 or more variables:

```cup
//global declaration and initialization
global_var_init ::= var_list EQ ass_list  {://check is sizes match and generate error if not
 
                                            for(int i=0; i<currentSymTable.varList.size(); i++){ //var list stores the ValueObj of those var
                                                ValueObj ValueObjectOfVar = currentSymTable.varList.get(i); //get valueObj of that var
                                                ValueObj tmp = currentSymTable.get(ValueObjectOfVar.name); //try to get it from symbol table
                                                 if(tmp == null){				                     //if null, it has never been declared
                                                    if(currentSymTable.isFunc){
                                                        pSemError("CANNOT DECLARE GLOBAL VARIABLES INSIDE FUNCTION");
                                                    }
		                                                globalSymbolTable.varTable.put(ValueObjectOfVar.name, ValueObjectOfVar); //put in simbol table
                                                    initVar(ValueObjectOfVar, currentSymTable.expList.get(i)); //init var
                                                 }else{
                                                    initVar(tmp, currentSymTable.expList.get(i)); //if it has been already declared, pass the valueObj of the symbol table
                                                  }
 
                                            }
                                            currentSymTable.varList.clear();
                                            currentSymTable.expList.clear();
 
                                          :};
``` 
    

In Lua, the declaration or assignment of global variables looks the same. From the parser's point of view, the declaration and the assignment are different.

After receiving all the tokens needed ( `var_list EQ ass_list` ), the parser can execute the related action. It consists of a for loop (one iteration for each variable, line 5). Each iteration can be divided into 3 parts:

*   Retrieve the `ValueObj` (data structure for variables) for the variable we are processing and check if it is null.
    
*   If it is `null`, the variable must be declared. Put the variable in the symbol table and initialize it using `initVar` (function that does the job)
    
*   If it is `not null`, the variable must just be initialized with a new value. Function `initVar` (same as the one used above) is used.
    

Function `initVar` (not reported here for sake of brevity), assigns to the variable the corresponding value.

**Example**

```lua
a, b = 5, 6
 
a = 4
b = 10
```    

```llvm
declare i32 @printf(i8*, ...)
 
@a = global double 5.0, align 8
@b = global double 6.0, align 8
 
 
define void @main(){
store double 5.0, double* @a, align 8
store double 6.0, double* @b, align 8
store double 4.0, double* @a, align 8
store double 10.0, double* @b, align 8
ret void
}
```
    

Line 1 of Lua code, generates lines 3-4 of the LLVM IR code. The code is not optimized, and for sake of generality, lines 8-9 of IR code is also generated. This could be avoided in order to optimize the code.

Line 3-4 of Lua code, generate lines 10-11 of IR code. The variables are already declared, so it is sufficient to use store instructions to store the desired values.

### If Else statements

```cup
if_block ::= IF  {:  currentSymTable = new SymbolTable(currentSymTable, false); 
                    loopCount = ++totLoopCount; loopList.push(loopCount);//when entering a statement, save the loop number on the stack
                :} loop_cond:x {:
                    appendMainBuffer(("br i1 " + x.scope+x.name + ", label %if.body." + loopCount + ", label %if.else." + loopCount), true);
                :}  THEN {:
                    appendMainBuffer(("if.body." + loopCount + ":"), true);:} stmt_list   {:loopCount=loopList.pop();:} //pop here to retrieve my loop nubmber ;
                         else_block END
 
                | IF error stmt_list else_block END{: pSynWarning("ERROR IN IF CONDITION");:};
 
else_block ::= {: 
                     appendMainBuffer(("br label %if.exit." + loopCount), true);
                :} ELSE {: 
                    appendMainBuffer(("if.else." + loopCount + ":"), true); 
                    loopList.push(loopCount);
                :}stmt_list {:
 
                     loopCount=loopList.pop();
                    appendMainBuffer(("br label %if.exit." + loopCount), true);
                    appendMainBuffer(("if.exit." + loopCount + ":"), true);
                    currentSymTable=currentSymTable.getPrev(true);
 
 
                    :}|
                    {:
                        appendMainBuffer(("br label %if.else." + loopCount), true);
                        appendMainBuffer(("if.else." + loopCount + ":"), true); 
                        currentSymTable=currentSymTable.getPrev(true);
                    :} ;
```		    
    

This parser supports `if-then-else` statements nested (any depth). The implementation of this may seem tricky, but it is actually straightforward. Let us analyze the code in detail:

After receiving the `IF` token (line 1), the parser enters in a new local scope and thus needs to create a new symbol table. At line 2, variable `totLoopCount` is present. This variable is needed in order to correctly enumerate the labels needed to perform the various jump in the if-else statements. A correct numeration of this is essential, as there cannot be duplicated and each label must identify an exact location in the code.

In order to achieve this, the variable `totLoopCount` is incremented whenever a new set of labels must be generated and never decremented. This is not enough: if we want to have multiple levels of nestings, upon exiting a nested if-else, it is necessary to restore the correct label number in `loopCount`, as it is needed in a possible else statement that follows.

A LIFO list (a stack) is used for this purpose. At line 2, the label number assigned to this if statement is used is save in a variable (`loopCount`) and `totLoopCount` incremented. Immediately after, `loopCount` is saved on the stack (`loopList`). For all the following label of the current if, the saved number is used in the label. When entering another if statement in the body (nested if), the same procedure happens again. Upon exiting the if in the body of the upper level if (line 6, after `stmt_list`), the label number is popped from the stack.

This procedure can be applied recursively and always guarantees that each if statement retrieves the right label number. In the else\_block rule, a similar procedure (identical in the logic) happens. The else\_block symbol is always needed in the if\_block rule: when there is actually an else statement, this is parsed, otherwise and else block is reduced from the empty string (Line 24). At the end, the previous symbol table must be restored (line 21 or 28, depending on the case).

### Repeat until statement

`Repeat-until` statements corresponds to `do-while` in C code. The parser code to translate it into LLVM IR code is similar (if not almost identical) to the one used to implement the `do-while` of Lua.

```cup
repeat_loop ::= REPEAT  {:
                            currentSymTable = new SymbolTable(currentSymTable, false); 
                            loopCount = ++totLoopCount;
                            loopList.push(loopCount); //when entering a statement, save the loop number on the stack
                            appendMainBuffer(("br label %for.body." + loopCount), true);
                            appendMainBuffer(("for.body." + loopCount + ":"), true);
                        :}
                        stmt_list 
                        {: 
                            loopCount=loopList.pop(); //restore it when statement is finished                   
                            appendMainBuffer(("br label %for.cond." + loopCount), true);
 
                        :}
                        UNTIL 
                        {:
                            appendMainBuffer(("for.cond." + loopCount + ":"), true);
                        :}
                        loop_cond:x
                        {:                        
                            appendMainBuffer(("br i1 " + x.scope+x.name + ", label %for.body." + loopCount + ", label %for.exit." + loopCount), true);
                            appendMainBuffer(("for.exit." + loopCount + ":"), true);
                            currentSymTable=currentSymTable.getPrev(true);
                        :}
 
                   ; 
```
    

The above code does the following:

*   After receiving the `REPEAT` token (line 2), the related action is performed. It consists of creating a new symbol table for the local scope block in which we are entering. Also, as for the if loop, variable `loopCount`, `totLoopCount` and `loopList` take care of preserving the correctness of label numbering (explanation is the same as for the `if` statement). LLVM IR code is appended to the main buffer: an unconditional branch instruction to the start of the loop (lines 6-7).
    
*   A `stmt_list` token is received, representing the body. Nested statements are possible inside the body. After the entire body is parsed, the correct label number is restored (line 11) and an unconditional jump is appended to the buffer, allowing to go to the evaluation of `REPEAT-UNTIL` condition.
    
*   At line 17, the label for evaluating the condition is inserted.
    
*   Then, the loop\_cond token is received. It is a `ValueObj` object storing the information of the condition evaluated. The semantic action inserts in the main buffer a conditional branch instruction: if the `loop_cond` is `true`, we jump to the beginning of the loop, otherwise, we proceed to the exit and restore the previous symbol table (lines 21-23).
    

An example
----------

**Lua source code**

```lua
i=6
while i>1 do
    j=1
    while j<i do
 
        print("*")
        j=j+1
    end
 
print( "\n")
i=i-1
end
```
**After compilation**

```llvm
declare i32 @printf(i8*, ...)
@.str.0 = private constant [2 x i8] c"*\00", align 1
@.str.1 = private constant [2 x i8] c"\0A\00", align 1
 
@i = global double 6.0, align 8
@j = global double 1.0, align 8
 
 
define void @main(){
store double 6.0, double* @i, align 8
br label %for.cond.1
for.cond.1:
%1 = load double, double* @i, align 8
%2 = fcmp ogt double %1, 1.0
br i1 %2, label %for.body.1, label %for.exit.1
for.body.1:
store double 1.0, double* @j, align 8
br label %for.cond.2
for.cond.2:
%3 = load double, double* @j, align 8
%4 = load double, double* @i, align 8
%5 = fcmp olt double %3, %4
br i1 %5, label %for.body.2, label %for.exit.2
for.body.2:
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.0, i32 0, i32 0))
%7 = load double, double* @j, align 8
%8 = fadd double %7, 1.0
store double %8, double* @j, align 8
br label %for.cond.2
for.exit.2:
%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
%10 = load double, double* @i, align 8
%11 = fsub double %10, 1.0
store double %11, double* @i, align 8
br label %for.cond.1
for.exit.1:
ret void
}

```

**Output running LLVM IR**
```
*****
****
***
**
*
```
What has been implemented
-------------------------

Implementation list: [impl\_list](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/WhatIsImplemented.pdf "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/WhatIsImplemented.pdf")

Download and installation
-------------------------

Following, you can find:

*   The **compiler archive**, containing:
    
    *   Parser (parser.cup)
        
    *   Scanner (scanner.jflex)
        
    *   Makefile
        
    *   skeleton.nested
        
*   **Examples archives**. Each example archive contains:
    
    *   \[Example\_name\].lua (Lua source code)
        
    *   parser.cup
        
    *   scanner.jflex
        
    *   skeleton.nested
        
    *   Makefile
        
    *   Main.java
        
    *   out.ll (LLVM IR output file generate by the command lli \[Example\_name\].lua)
        
    *   Possibly additional .lua file used as libraries.
        

Each example archive containes the _Lua_ source code and the corresponding output in _LLVM IR_, generated by the compiler as well as all needed external files (such as Math.lua or stack.lua). In order to facilitate the compilation, each example archive contains the scanner, the parser, and all other files necessary to make the compiler work. Furthermore, the LLVM IR output file is also included. In a system supporting Make, it is enough to open the folder in a terminal and run Make. For a Windows system or for a full description, follow the guides below.

### Compiler

Archive containing parser (parser.cup), scanner (scanner.jflex) and Makefile (as well as skeleton.nested used by the scanner) [lua\_compiler](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/lua-compiler.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/lua-compiler.zip")

### Examples

*   Armstrong numbers: [armstrong\_numbers](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/armstrong_numbers.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/armstrong_numbers.zip")
    
*   Fibonacci series: [fibonacci\_series](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/fibonacci_series.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/fibonacci_series.zip")
    
*   Bubble sort: [bubble\_sort](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/bubble_sort.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/bubble_sort.zip")
    
*   Prime numbers: [prime\_numbers](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/prime_numbers.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/prime_numbers.zip")
    
*   Floyd triangle: [floyd\_triangle](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/floyd_triangle.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/floyd_triangle.zip")
    
*   Stack demo: [stack\_demo](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/stack_demo.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/stack_demo.zip")
    
*   not demo: [not\_demo](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/not_demo.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/not_demo.zip")
    

### External libraries

(must be used in another program or modified)

*   Math: [Math.lua](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/Math.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/Math.zip")
    
*   Stack: [stack.lua](https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/stack.zip "https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/stack.zip")
    

### How to run it on Linux/Mac systems

_**NOTE:**_

**jFlex v1.8.2** is needed in order to make it run. Lower versions do not work correctly (in this particular case).

*   If you want to check your version, open the terminal and run `jflex -version`.
    
*   If you have installed jFlex with the apt manager or you installed a lower version, you can run `sudo apt remove jflex` to uninstall it and follow the below guide to install the correct version.
    
*   If you have installed jFlex manually, you have to remove manually too (based on where files have been placed).
    

1.  Install, if you have not already done so:
    
    1.  _**llvm**_ package:
        
        1.  Linux: `sudo apt install llvm`
            
            1.  Mac: `brew install -with-toolchain llvm`
                
    2.  Linux: **jFlex v1.8.2** (just copy, paste and press enter in the terminal, even with comments)
```bash
	#remove old version is present
	sudo apt remove jflex
	#download jFlex archive 
	cd $HOME
	wget https://github.com/jflex-de/jflex/releases/download/v1.8.2/jflex-1.8.2.tar.gz
	#decompress it and move to the correct location
	sudo tar -C /usr/share -xvzf jflex-1.8.2.tar.gz
	#create a link in /usr/bin
	sudo ln -s /usr/share/jflex-1.8.2/bin/jflex /usr/bin/jflex
	#add correct user rights
	sudo chmod -R 755 /usr/share/jflex-1.8.2
	sudo chmod 755 /usr/bin/jflex
	#remove downloaded archive
	rm jflex-1.8.2.tar.gz
```

   3.  **jFlex v1.8.2** (only for macOS) and **CUP** - **NOTE:** For Linux set-up, skip the part regarding the installation of jFlex in the below guide.
        
        1.  [Install Linux Bash](https://www.skenz.it/compilers/install_linux_bash "compilers:install_linux_bash"): How to download, install and configure Jflex, Java, and Cup in the Ubuntu Linux operating system with bash shell  
            
        2.  [Install macOS](https://www.skenz.it/compilers/install_macos "compilers:install_macos"): How to download, install and configure Jflex, Java, and Cup in the macOS operating system  



        
  
            
2.  If you want to run one of the examples (_substitute fibonacci_series with the name of the example you want to run, if different)
```bash
      	# first two commands create a folder in the desktop to run the example: you can skip them if you want to download it somewhere else
        cd $HOME/Desktop
        mkdir -p run_example 
        cd run_example
        wget https://www.skenz.it/repository/compilers/ass/lua_to_LLVM/fibonacci_series.zip #substitute fibonacci_series with the example you want to run
        unzip fibonacci_series.zip #substitute fibonacci_series with the example you want to run
        rm fibonacci_series.zip
        cd fibonacci_series #substitute fibonacci_series with the example you want to run
        make
        make run
        lli out.ll
```
    
3.  If you want to run the lua compiler with an arbitrary (compatible with the compiler) .lua file
    
4.  Download the _lua compiler_ and extract it
    
5.  Open the terminal, go to the folder where the compiler is extracted and run:
    
    1.  `make`
        
    2.  As alternative to using the Makefile, run the following commands from the same folder where lua compiler is:
        
```bash
	 java java_cup.Main -parser parser parser.cup
	 jflex -skel skeleton.nested scanner.jflex
	 javac *.java
```

1.  Take a `.lua` file (from the examples or write a piece of code supported by the compiler)
    
2.  Run the compiler, passing the `.lua` file as input
    
    1.  `java Main [filename].lua`
        
3.  Run the output file with the command _lli_: `lli [filename].ll`
    

**NOTE**: The procedure has been tested on Linux, not on macOS.

### How to run it on WSL/WSL2 systems

The procedure is the same as for LINUX systems. It has been tested and works correctly on WSL2.

### How to run it on Windows systems

On Windows it is possible to use both the scanner and compiler, but it is not possible to run LLVM IR code.

\- Install, if you have not already done so:

1.  jFlex v1.8.2 and CUP
    
    1.  [Install Windows](/compilers/install_windows "compilers:install_windows"): How to download and install Jflex, Java, and Cup in the Windows operating system  
        
2.  Download the _lua compiler_ and extract it
    
3.  Open the terminal, go to the folder where the compiler is extracted and run:
    
    1.  `java java_cup.Main -parser parser parser.cup`
        
    2.  `jflex -skel skeleton.nested scanner.jflex`
        
    3.  `javac *.java`
        
4.  Take a `.lua` file (from the examples or write a code supported by the compiler)
    
5.  Run the compiler, passing the `.lua` file as input
    
6.  `java Main [filename].lua`
    
7.  You can open the out.ll file with a text editor
    


