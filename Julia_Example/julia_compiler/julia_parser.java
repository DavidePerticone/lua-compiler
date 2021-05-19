import java_cup.runtime.*;
import java.io.*;
import java.util.HashMap;
import java.util.Map.*;
import java.util.ArrayList;
import java.util.regex.*;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

init with {:

	symbolTable = new HashMap<String, TypeVar>();
	functionTable = new HashMap<String, TypeFun>();
	printBuff = new StringBuffer();
	stringDef = new ArrayList<String>();
	retType = new String("void");
	bwr = new BufferedWriter(new FileWriter(new File("output.ll")));

:};

parser code {:

	//Contains the corrispondence among variables ID and TypeVar
	public HashMap <String, TypeVar> symbolTable;
    //Contains the corrispondence among variables ID and TypeFun 
	public HashMap <String, TypeFun> functionTable;
	public boolean isCorrect = true; //to check if the program contains errors
	//Represents the output to print out when the parsing process is complete
	public StringBuffer printBuff;
	//String definition to print ount at the beginning of the ll file 
	public ArrayList<String> stringDef;

	//Global counter of the registers used in the ll file
	public int var_label = 0;
	//Global counter used to instantiate string ids
	public int str_label = 0; 

    //Label for control flow instructions 
	public int flow_label = 0;

	public int tot_flow_label = 0;

    //To write on an output.ll file the StringBuffer
	public BufferedWriter bwr;

	public String retType;
	public int genVarLabel(){

		var_label++;

		return var_label; 
	};

	public int genStrLabel(){

		str_label++;

		return str_label; 
	};
	//Entity that represents the variable (numerical and nominal)
	public class TypeVar{

		public String reg_id;
		public String type; //i32, double,...
		public String value; //if numerical this is the string converted value
		public Integer align;  //alignment required: 4, 8...
		public Integer size1; //if the variable is an array then this is its size, otherwise size1 = -1 
		public Integer size2;
		public Integer l; //used only for while instructions and needed for 

		public TypeVar()
		{
			reg_id = Integer.toString(genVarLabel());
			size1 = size2 = -1;
		}
		TypeVar(Integer value, String type, Integer align)
		{
			this();
			this.value = Integer.toString(value);
			this.type = type;
			this.align = align;
		}

		TypeVar(Double value, String type, Integer align)
		{
			this();
			this.value = Double.toString(value);
			this.type = type;
			this.align = align;
		}


	}

	public class TypeFun{

		ArrayList<String> parT; //list of paramters type
		Integer nPar; //number of parameters 
		String retT; //return type 

		public TypeFun(ArrayList<String> parT, String retT)
		{
			this.parT = parT;
			this.nPar = parT.size(); 
			this.retT = retT;
		}

	}
	
	public void syntax_error(Symbol cur_token){}

	public Object stack(int position) {

        return (((Symbol)stack.elementAt(tos+position)).value);

    }
	public int getLine() {

		if (((Symbol)stack.elementAt(tos)).left != -1){

			return ((Symbol)stack.elementAt(tos)).left+1;

		}else return -1;

	}

	public int getColumn() {

		if (((Symbol)stack.elementAt(tos)).left != -1){

			return ((Symbol)stack.elementAt(tos)).right+1;

		}else return -1;

	}


:};

action code {:


    //to print semantic error 
	private void pSemError(String message){

		System.err.println("SEMANTIC ERROR: line: "+parser.getLine()+" column: "+parser.getColumn()+": "+message);

		parser.isCorrect = false;

		parser.done_parsing();

	}
    //to print semantic warnings 
	private void pSynWarning(String message){

		System.err.println("SYNTACTIC WARNING (line: "+parser.getLine()+" column: "+parser.getColumn()+"): "+message);

		parser.isCorrect = false;

	}

    //to append string to the StringBuffer
	public void append(String s, boolean newLine){

		printBuff.append(s);

		if (newLine)
			printBuff.append("\n");

	}
	/*Function used to create a string definition starting from the string x, 
	it'a also able to manage interpolated variables in the string*/
	public void CreateString(Boolean nl, String x)
	{

		Boolean interpolation = false;
		ArrayList <TypeVar> interpVar = new ArrayList<TypeVar>();
		int label = genStrLabel();
		TypeVar t = null;
		String s = x;
		s = s.replace("\"", "");
		
		

		//Search variables name starting with $ and replace them with "%d"; works only for integers
		Pattern pattern = Pattern.compile("\\$\\w+");

		Matcher matcher = pattern.matcher(s);
		while (matcher.find())
		{
			interpolation = true;
			String find = matcher.group();

			s = s.replace(find,"%d");

			find = find.replace("$", ""); 

			if(!parser.symbolTable.containsKey(find))
			{
				pSemError("Variable "+find+" not declared.");
			}
			else if(parser.symbolTable.get(find).size1==-1){ //to print scalars 
				t = parser.symbolTable.get(find);
				if(t.type.equals("double"))
					s = s.replace("%d","%f");
				append("%"+genVarLabel()+" = load "+t.type+", "+t.type+"* %"+t.reg_id+", align "+t.align,true);	
				interpVar.add(t);
			}else{ //to print arrays
				t = parser.symbolTable.get(find);
				for(int i = 1; i<t.size1; i++)
				{
					s += " %d"; 
				}
				TypeVar elem; 
				for(int i=0; i<t.size1; i++)
				{
					append("%"+genVarLabel()+" = getelementptr inbounds ["+t.size1+" x "+t.type+"], ["+t.size1+" x "+t.type+"]* %"+t.reg_id+", "+t.type+" 0, "+t.type+" "+i,true);
					elem = new TypeVar();
					append("%"+elem.reg_id+" = load "+t.type+" , "+t.type+"* %"+(var_label-1)+", align "+t.align,true);
					elem.type = t.type; 
					elem.align = t.align; 
					interpVar.add(elem);
				}
				

			}


		}
		if (nl)
		{
			s = s + "\\0A";
			
		}
		
		s = s + "\\00";
		s = s.replace("$", ""); 
		Integer length = s.length()-(nl?4:2);

		parser.stringDef.add("@.str." + label + " = private constant [" + length + " x i8] c\"" + s + "\", align 1");

		append(("%" + genVarLabel() + " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + length + " x i8], [" + length + " x i8]* @.str." + label + ", i32 0, i32 0)"), false);
		if(interpolation)
		{
			append(", ",false);
			for (int i = 0; i < interpVar.size(); i ++)
			{
				TypeVar intV = interpVar.get(i);
				if(i==0)
					append(intV.type+" %"+(t.size1==-1?(var_label-interpVar.size()):intV.reg_id), false);
				else
					append(", "+intV.type+" %"+(t.size1==-1?(var_label-interpVar.size()+i):intV.reg_id),false);						         
			}

		}
		append(")",true);
	}

	//Function to add entries in the symbolTable
	public void addEntry(String x, TypeVar y)
	{
		if(!parser.symbolTable.containsKey(x))
		{
			y.value = x;
			parser.symbolTable.put(x,y);
		}else{
		    //if x is not already defined we have to use a new register and add the correspondent entry in the table
			TypeVar xVar = parser.symbolTable.get(x);
			TypeVar yVar = y;
			append("%"+genVarLabel()+" = load "+yVar.type+", "+yVar.type+"* %"+yVar.reg_id+", align "+yVar.align,true);	
			append("store "+yVar.type+" %"+(var_label)+", "+xVar.type+"* %"+xVar.reg_id+", align "+xVar.align,true);
			
		}

	}

	



:}


//Terminal tokens
terminal RO, RC, SC, SO;
terminal EQU, PLUS, MINUS, STAR, DIV;
terminal MIN, MAJ, MINEQU, MAJEQU, EQEQ, NEQ;
terminal AND, OR, NOT;
terminal ELSE, END, FOR;
terminal FUNCT, IF, IN, PRINT,PRINTLN, RET, WHILE;
terminal C, COL, SEMIC;
terminal Integer INT;
terminal Double DOUBLE;
terminal String ID;
terminal String STRING;
terminal uminus;



//Non terminal tokens
non terminal assignment;
non terminal String comp;
non terminal TypeVar comparison;
non terminal compound_assign;
non terminal String compound_op;
non terminal TypeVar condition;
non terminal TypeVar dest_var;
non terminal TypeVar elem;
non terminal ArrayList<TypeVar> elem_list;
non terminal elem_list_matr;
non terminal elem_list_touple;
non terminal else_stat;
non terminal elseif_list;
non terminal for_instr;
non terminal TypeVar[] for_range;
non terminal TypeVar funct_call;
non terminal function_def;
non terminal function_defs;
non terminal ArrayList<String> ID_list;
non terminal if_instr;
non terminal ArrayList<TypeVar> input_par;
non terminal instruction;
non terminal String log_op;
non terminal TypeVar logic;
non terminal matr_elem;
non terminal TypeVar op;
non terminal TypeVar operand;
non terminal String operation;
non terminal String param;
non terminal print_instr;
non terminal Boolean print_keyw;
non terminal prog;
non terminal ret_instr;
non terminal signed_matr_elem;
non terminal TypeVar signed_op;
non terminal TypeVar signed_val;
non terminal TypeVar signed_vec_elem;
non terminal statement;
non terminal statements;
non terminal TypeVar term;
non terminal TypeVar val;
non terminal TypeVar vec_elem;
non terminal while_instr;



precedence left RET;
precedence left PLUS, MINUS;
precedence left STAR, DIV;
precedence left uminus;




/////////////////////////
// Grammar start
/////////////////////////

start with prog;


//it's given that the program is composed of function definitions first and then there's code that has to be included in the main
prog ::= function_defs {:
	if(parser.isCorrect)
	{
		bwr.write("declare i32 @printf(i8*, ...)\n");
		
		bwr.write(printBuff.toString());
		
	}
	else
		System.out.println("Program contains errors.");
    //After being used for function definitions, var_label and printBuff are re-set to be used for main instructions
	var_label = 0; 
	printBuff.setLength(0);
	
:}statements {:
	if(parser.isCorrect)
	{
		for(String s : stringDef)
		{
			bwr.write(s+"\n");
		}

		bwr.write("define void @main(){\n");
	
		bwr.write(printBuff.toString());
	
		bwr.write("ret void\n}");
		bwr.flush();
 
		//close the stream
		bwr.close();
	}
	else
		System.out.println("Program contains errors.");

:};

statements ::= statement
| statements statement;

statement ::= assignment
| compound_assign
| instruction
| funct_call
;

function_defs ::= |
function_defs function_def;

instruction ::= ret_instr | while_instr | if_instr | for_instr | print_instr ;

/*dest_var represents array or matrix elements
ID represent a variable
Array elements can be assigned to
operations (arithmetic and logic), signed scalars,
signed array elements.
Variables can be assigned to these elements, arrays, function call. 
*/
assignment ::= dest_var:x EQU signed_op:y {:

	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+y.type+" , "+y.type+"* %"+y.reg_id+", align "+y.align,true);
	append("store "+y.type+" %"+newReg+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);



:}
| dest_var:x EQU operand:y{:

	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+y.type+" , "+y.type+"* %"+y.reg_id+", align "+y.align,true);
	append("store "+y.type+" %"+newReg+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);

:}
| dest_var EQU funct_call
| dest_var:x EQU signed_vec_elem:y{:
	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+y.type+" , "+y.type+"* %"+y.reg_id+", align "+y.align,true);
	append("store "+y.type+" %"+newReg+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);
:}
| dest_var EQU signed_matr_elem
| dest_var EQU STRING
| dest_var EQU error {:pSynWarning("Error in assignment.");:}
| ID:x EQU signed_op:y {:
	y.value = x;
	
	addEntry(x,y);
:}
| ID:x EQU signed_val:y {:

	addEntry(x,y);

:}
| ID:x EQU funct_call:y {:
	addEntry(x,y);
:}
| ID:x EQU signed_vec_elem:y{:
	append("%"+genVarLabel()+" = load "+y.type+", "+y.type+"* %"+y.reg_id+", align "+y.align,true);	
	append("%"+genVarLabel()+" = alloca "+y.type+", align "+y.align, true);
	append("store "+y.type+" %"+(var_label-1)+", "+y.type+"* %"+(var_label), true);
	y.reg_id = Integer.toString(var_label);
	addEntry(x,y);
:}
| ID EQU signed_matr_elem
| ID EQU STRING
| ID EQU logic
//array
| ID:id EQU SO elem_list:x SC{:
	TypeVar nTypeVar = new TypeVar(); 
	Integer arrReg = Integer.parseInt(nTypeVar.reg_id);
	append("%"+arrReg+" = alloca ["+x.size()+" x "+x.get(0).type+"], align "+x.get(0).align, true);
	for(int i = 0; i<x.size(); i++)
	{
		TypeVar xTy = x.get(i); 	
		append("%"+genVarLabel()+" = getelementptr inbounds ["+x.size()+" x "+x.get(i).type+"], ["+x.size()+" x "+x.get(i).type+"]* %"+arrReg+", "+x.get(i).type+" 0, "+x.get(i).type+" "+i,true);
		append("%"+genVarLabel()+" = load "+xTy.type+", "+xTy.type+"* %"+xTy.reg_id+", align "+xTy.align,true);	
		append("store "+xTy.type+" %"+var_label+", "+xTy.type+"* %"+(var_label-1)+", align "+xTy.align,true);
	} 
	
	nTypeVar.type = x.get(0).type;
	nTypeVar.align = x.get(0).align;
	nTypeVar.size1 = x.size();
	addEntry(id, nTypeVar );

:}
| ID EQU SO elem_list error {:pSynWarning("Missing ] in array definition.");:}
| ID EQU SO elem_list_matr SC
| ID EQU SO elem_list_matr error {:pSynWarning("Missing ] in matrix definition.");:}
| ID EQU RO elem_list_touple RC
| ID EQU error {:pSynWarning("Error in assignment.");:}
;


dest_var ::=  vec_elem:x {:RESULT = x; :} 
| matr_elem
;


//List of comma separated IDs or integers or doubles

elem_list ::= elem:x {:
	RESULT = new ArrayList<TypeVar>();
	RESULT.add(x);
:}
| elem_list:x C elem:y{:

	x.add(y);
	RESULT = x;

:};

elem ::= operand:x {:RESULT = x;:} | signed_op:x {:RESULT = x;:};

elem_list_touple ::= val | STRING | elem_list_touple C val | elem_list_touple C STRING;

elem_list_matr ::= elem_list SEMIC elem_list | elem_list_matr SEMIC elem_list;

val ::= ID:x {:
	if(!parser.symbolTable.containsKey(x))
	{
		pSemError("Variable "+x+" not declared.");	
	}else{
		RESULT = parser.symbolTable.get(x);

	}

:}
| INT:x {:
	RESULT = new TypeVar(x, "i32", new Integer(4));
	append("%"+RESULT.reg_id+" = alloca "+RESULT.type+", align "+RESULT.align, true);
	append("store "+RESULT.type+" "+RESULT.value+", "+RESULT.type+"* %"+RESULT.reg_id, true);
:}
| DOUBLE:x {:
	RESULT = new TypeVar(x, "double", new Integer(8));
	append("%"+RESULT.reg_id+" = alloca "+RESULT.type+", align "+RESULT.align, true);
	append("store "+RESULT.type+" "+RESULT.value+", "+RESULT.type+"* %"+RESULT.reg_id, true);
:}
;

signed_val ::= MINUS val:x  {:
	
	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
	Integer newReg1 = genVarLabel();
	append("%"+newReg1+" = "+(x.type.equals("double")?"f":"")+"mul "+x.type+" %"+newReg+", -1"+(x.type.equals("double")?".0":""),true);
	append("%"+genVarLabel()+" = "+"alloca "+x.type+", align "+x.align,true);
	append("store "+x.type+" %"+newReg1+", "+x.type+"* %"+var_label,true);
	RESULT = x;
	RESULT.reg_id = Integer.toString(var_label);
:} %prec uminus
| val:x {:RESULT = x;:}


;


//Array element - index notation

vec_elem ::= ID:v SO signed_val:x SC {:
	
	
	if(!parser.symbolTable.containsKey(v))
	{
		pSemError("Variable "+v+" not declared.");	

	}else if(parser.symbolTable.get(v).size1 == -1){
		pSemError("Variable "+v+" is not an array.");	
	}
	else{
		TypeVar vec = parser.symbolTable.get(v); 
		Integer precVarLabel = var_label;
		Integer prevId = genVarLabel();
		append("%"+prevId+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
		prevId = var_label;
		append("%"+genVarLabel()+" = sub i32"+" %"+prevId+", 1",true);
		prevId = var_label;
		RESULT = new TypeVar();
		append("%"+RESULT.reg_id+" = getelementptr inbounds ["+vec.size1+" x "+vec.type+"], ["+vec.size1+" x "+vec.type+"]* %"+vec.reg_id+", "+vec.type+" 0, "+vec.type+" %"+prevId,true);
		RESULT.type = vec.type; 
		RESULT.align = vec.align; 
	}
:}| ID:v SO signed_op:sop SC{:


	if(!parser.symbolTable.containsKey(v))
	{
		pSemError("Variable "+v+" not declared.");	

	}else if(parser.symbolTable.get(v).size1 == -1){
		pSemError("Variable "+v+" is not an array.");	
	}
	else{
		TypeVar vec = parser.symbolTable.get(v); 
		Integer precVarLabel = var_label;
		Integer prevId = genVarLabel();
		append("%"+prevId+" = load "+sop.type+" , "+sop.type+"* %"+sop.reg_id+", align "+sop.align,true);
		prevId = var_label;
		append("%"+genVarLabel()+" = sub i32"+" %"+prevId+", 1",true);
		prevId = var_label;
		RESULT = new TypeVar();
		append("%"+RESULT.reg_id+" = getelementptr inbounds ["+vec.size1+" x "+vec.type+"], ["+vec.size1+" x "+vec.type+"]* %"+vec.reg_id+", "+vec.type+" 0, "+vec.type+" %"+prevId,true);
		RESULT.type = vec.type; 
		RESULT.align = vec.align; 
	}
:} ;

signed_vec_elem ::= MINUS vec_elem:x {:

	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
	Integer newReg1 = genVarLabel();
	append("%"+newReg1+" = mul "+x.type+" %"+newReg+", -1",true);
	append("%"+genVarLabel()+" = "+"alloca "+x.type+", align "+x.align,true);
	append("store "+x.type+" %"+newReg1+", "+x.type+"* %"+var_label,true);
	RESULT = x;
	RESULT.reg_id = Integer.toString(var_label);
	


:} %prec uminus
| vec_elem:x{:
	RESULT = x;
:};


//Matrix element - index notation

matr_elem ::= vec_elem SO val SC | vec_elem SO signed_op SC;

signed_matr_elem ::= MINUS matr_elem %prec uminus
| matr_elem;


//Arithmetic operation

signed_op ::= op:x {:RESULT = x;:}| MINUS op:x {:

	Integer newReg = genVarLabel();
	append("%"+newReg+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
	Integer newReg1 = genVarLabel();
	append("%"+newReg1+" = mul "+x.type+" %"+newReg+", -1",true);
	append("%"+genVarLabel()+" = "+"alloca "+x.type+", align "+x.align,true);
	append("store "+x.type+" %"+newReg1+", "+x.type+"* %"+var_label,true);
	RESULT = x;
	RESULT.reg_id = Integer.toString(var_label);
	
:}%prec uminus;

op ::= operand:x operation:o operand:y {:
	if(!x.type.equals(y.type))
	{
		if(x.type.equals("i32")&&y.type.equals("double"))
		{
			append("%"+genVarLabel()+" = uitofp i32 "+x.value+" to double",true);
			x.reg_id = Integer.toString(var_label);
			x.type = "double";
		}else if(y.type.equals("i32")&&x.type.equals("double"))
		{
			append("%"+genVarLabel()+" = fptoui double "+y.value+" to i32",true);
			y.reg_id =  Integer.toString(var_label);
			y.type = "double";
		}
	}
	append("%"+genVarLabel()+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
	Integer xReg = var_label;
	append("%"+genVarLabel()+" = load "+y.type+" , "+y.type+"* %"+y.reg_id+", align "+x.align,true);
	Integer yReg = var_label;
	RESULT = new TypeVar();
	if(x.type.equals("double"))
	{
		if(o.equals("sdiv"))
			o = o.replace("s","");

		o = "f"+o; 
	}
	append("%"+RESULT.reg_id+" = "+o+" "+x.type+" %"+xReg+", %"+yReg,true);
	append("%"+genVarLabel()+" = "+"alloca "+x.type+", align "+x.align,true);
	append("store "+x.type+" %"+RESULT.reg_id+", "+x.type+"* %"+var_label,true);
	RESULT.reg_id = Integer.toString(var_label);
	RESULT.type = x.type;
	RESULT.align = x.align;

:}
| op:x operation:o operand:y{:
	if(!x.type.equals(y.type))
	{
		if(x.type.equals("i32")&&y.type.equals("double"))
		{
			append("%"+genVarLabel()+" = uitofp i32 "+x.value+" to double",true);
			x.reg_id = Integer.toString(var_label);
			x.type = "double";
		}else if(y.type.equals("i32")&&x.type.equals("double"))
		{
			append("%"+genVarLabel()+" = fptoui double "+y.value+" to i32",true);
			y.reg_id =  Integer.toString(var_label);
			y.type = "double";
		}
	}
	
	append("%"+genVarLabel()+" = load "+x.type+" , "+x.type+"* %"+x.reg_id+", align "+x.align,true);
	Integer xReg = var_label;
	append("%"+genVarLabel()+" = load "+y.type+" , "+y.type+"* %"+y.reg_id+", align "+x.align,true);
	Integer yReg = var_label;
	RESULT = new TypeVar();
	if(x.type.equals("double"))
		o = "f"+o; 
	append("%"+RESULT.reg_id+" = "+o+" "+x.type+" %"+xReg+", %"+yReg,true);
	append("%"+genVarLabel()+" = "+"alloca "+x.type+", align "+x.align,true);
	append("store "+x.type+" %"+RESULT.reg_id+", "+x.type+"* %"+var_label,true);
	RESULT.reg_id = Integer.toString(var_label);
	RESULT.type = x.type;
	RESULT.align = x.align;


:}
| RO op RC
;


operand ::= signed_val:x {:
	
	RESULT = x; 
	

:} %prec uminus
| signed_vec_elem:x {:
	
	RESULT = x; 
	

:}
| signed_matr_elem;


operation ::= PLUS {:RESULT = new String("add");:}
| MINUS {:RESULT = new String("sub");:}
| STAR {:RESULT = new String("mul");:}
| DIV {:RESULT = new String("sdiv");:}

;

//Compound operation (e.g. i+=1)
compound_assign ::= operand:x compound_op:o operand:y{:

	
	if(x.type.equals("double"))
		o = "f"+o; 
	append("%"+genVarLabel()+" = load "+x.type+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);	
	Integer xReg = var_label;
	append("%"+genVarLabel()+" = load "+y.type+", "+y.type+"* %"+y.reg_id+", align "+y.align,true);	
	Integer yReg = var_label;
	append("%"+genVarLabel()+" = "+o+" "+x.type+" %"+xReg+", %"+yReg,true);
	append("store "+x.type+" %"+var_label+", "+x.type+"* %"+x.reg_id,true);
	
	
	
	
:};

compound_op ::= PLUS EQU {:RESULT = new String("add");:}
| MINUS EQU {:RESULT = new String("sub");:}
| STAR EQU {:RESULT = new String("mul");:}
| DIV EQU {:RESULT = new String("div");:}
;

//Comparison operation

comparison ::= term:x comp:c term:y {:

	String comp = new String("cmp");
	if (x.type.equals("double") || y.type.equals("double")){
       comp = "f"+comp;
	   switch (c) {
		    case "eq":
		   		c = "o"+c;
				break; 
			case "ne":
				c = "u"+c;
				break;
		    default:
				c = c.replace("s","o");
				break;
			
	   }
    }else{
		comp = "i"+comp;
	}
	String s;
	Integer l = 0;
	s = new String("%"+genVarLabel()+" = load "+x.type+", "+x.type+"* %"+x.reg_id+", align "+x.align);
	l += s.length();
	append(s ,true);	
	Integer xReg = var_label;
	s = new String("%"+genVarLabel()+" = load "+y.type+", "+y.type+"* %"+y.reg_id+", align "+y.align);
	l += s.length();
	append(s ,true);	
	Integer yReg = var_label;
	RESULT = new TypeVar();
	s = new String(("%" + var_label + " = " + comp + " " + c + " " + x.type + " %" + xReg+ ", %" + yReg));
    append(s, true);
    RESULT.l = l + s.length()+3; // 3 is due to newline chars
:}
| NOT comparison;

term ::= operand:x {:RESULT = x;:} | signed_op:x {:RESULT = x;:};

comp ::= MIN {:RESULT = new String("slt");:}
| MAJ {:RESULT = new String("sgt");:}
| MINEQU {:RESULT = new String("sle");:}
| MAJEQU {:RESULT = new String("sge");:}
| EQEQ {:RESULT = new String("eq");:}
| NEQ {:RESULT = new String("ne");:}
;


//Logical operation

logic ::= comparison:x {:RESULT = x;:} 
| logic:x log_op:lop comparison:y{:
	RESULT = new TypeVar();
	String s = new String(("%" + var_label + " = "+lop+" "+ x.type + " %" + x.reg_id + ", %" + y.reg_id));
	append(s, true);
	RESULT.l = x.l+s.length();

:};

log_op ::= AND {:RESULT = new String("and");:}
|OR {:RESULT = new String("or");:};


//Function call

funct_call ::= ID:fName RO input_par:p RC{:
	if(functionTable.containsKey(fName))
	{
		
		for(int i = 0; i<p.size();i++)
		{
			TypeVar t = p.get(i);
			append("%"+genVarLabel()+" = load "+t.type+", "+t.type+"* %"+t.reg_id+", align "+t.align,true);	
		}
		append(("%" + genVarLabel() + " = call double @"+fName+"("),false);
		for(int i = 0; i<p.size(); i++)
		{
			append(p.get(i).type+" %"+(var_label-p.size()+i), false); 
			if(i!=(p.size()-1))
				append(", ", false); 
		}
		append(")", true); 
		RESULT = new TypeVar(); 
		RESULT.type = "double";
		RESULT.align = 4;
		append("%"+RESULT.reg_id+" = alloca double, align 8", true);
		append("store double %"+(var_label-1)+", double* %"+var_label, true); 
	}else{
		pSemError("No function "+fName+" found.");	
	}


	
	 

:};

input_par ::= elem_list:e {: RESULT = e; :}| ; 


//Function definition 

function_def ::= FUNCT ID:f RO ID_list:par{:

	var_label = par.size()+1;
	append("define @"+f+"(",false); 
	for(int i = 0; i<par.size(); i++)
	{
		append("double", false); 
		if(i != (par.size()-1))
			append(", ", false); 
		else 
			append(") {", true); 
			
	}
	for(int i = 0; i<par.size(); i++)
	{
		Integer reg; 
		if(i==0)
			reg = var_label;
		else	
			reg = genVarLabel();
		append("%"+reg+" = alloca double, align 8", true);
		append("store double %"+i+", double* %"+reg, true); 
		TypeVar p = new TypeVar();
		var_label--;
		p.reg_id = Integer.toString(reg); 
		p.type = new String("double"); 
		p.align = new Integer(8);  
		addEntry(par.get(i), p);
			
	}
	



:} RC statements END{:
	append("}", true);
	String fName = parser.stack(-6).toString();
	ArrayList<String> pType= new ArrayList<String>();
	for(int i = 0; i<par.size(); i++)
	{
		pType.add("double");
	}
	TypeFun funct = new TypeFun(pType,retType);
	functionTable.put(fName,funct);

	pType.set((pType.size()-1), "double*");
	funct = new TypeFun(pType, retType);
	
	Integer index = printBuff.indexOf(fName)-2;
	printBuff.insert(index, " "+retType);

	
	retType = "void"; 
	var_label = 0;
	symbolTable.clear(); 
:};

param ::= ID:x {:RESULT = x;:} | ;

ID_list ::= param:x{:
	RESULT = new ArrayList<String>();
	RESULT.add(x);

:} 
| ID_list:l C param:x{:
	l.add(x);
	RESULT = l;
:}
;

//While instruction

while_instr ::= WHILE  
RO condition:x {:
	tot_flow_label++;
	flow_label = tot_flow_label; 
	String s1 = new String(("br label %while_cond." + flow_label+"\n"));
	String s2 = new String(("while_cond." + flow_label + ":"+"\n"));
	printBuff.insert(printBuff.length()-x.l, s1 + s2);
	
	
	append(("br i1 %" + x.reg_id + ", label %while_body." + flow_label + ", label %while_end." + flow_label), true);

	append("while_body." + flow_label + ":", true);	
:} RC statements{:
	append("br label %while_cond." + flow_label, true);
    append("while_end." + flow_label + ":", true);
	flow_label--;


:} END 
| WHILE RO error RC statements END {:pSynWarning("Error in while condition.");:}
| WHILE RO condition error statements END {:pSynWarning("Missing ) in while condition.");:}
;

condition ::= logic:x {:RESULT = x;:} ; 

//If instruction
if_instr ::= IF condition:x {:
	tot_flow_label++;
	flow_label = tot_flow_label; 
	append("br i1 %" + x.reg_id + ", label %true." + flow_label + ", label %false." + flow_label, true);
    append("true." + flow_label + ":", true);
:} statements //elseif_list 
else_stat END
| IF error statements elseif_list else_stat END {:pSynWarning("Error in if condition");:}
| IF RO condition:x RC{:
	tot_flow_label++;
	flow_label = tot_flow_label;  
	append("br i1 %" + x.reg_id + ", label %true." + flow_label + ", label %false." + flow_label, true);
    append("true." + flow_label + ":", true);
:} statements else_stat END
;


else_stat ::= {:
	append("br label %false." + flow_label, true);
	append("false." + flow_label + ":", true);
	flow_label--;
:}
| {:
	append("br label %end." + flow_label, true);
:}ELSE {:
	append("false." + flow_label + ":", true);
:} statements{:
	append("br label %end." + flow_label, true);
	append("end." + flow_label + ":", true);
	flow_label--;
:};

//For instruction

for_instr ::= FOR ID:x IN for_range:r {:

	append("%"+genVarLabel()+" = load "+r[0].type+" , "+r[0].type+"* %"+r[0].reg_id+", align "+r[0].align,true);
	Integer min = var_label;
	append("%"+genVarLabel()+" = load "+r[1].type+" , "+r[1].type+"* %"+r[1].reg_id+", align "+r[1].align,true);
	Integer max = var_label; 
	TypeVar iterator = new TypeVar();
	iterator.type = r[0].type;
	iterator.align = r[0].align;
	addEntry(x, iterator);
	append("%"+iterator.reg_id+" = "+"alloca "+r[0].type+", align "+r[0].align,true);
	append("store "+r[0].type+" %"+min+", "+r[0].type+"* %"+var_label,true);
	tot_flow_label++;
	flow_label = tot_flow_label; 
	append("br label %for_cond." + flow_label, true);
    
	append("for_cond." + flow_label + ":", true);
	append("%"+genVarLabel()+" = load "+r[0].type+" , "+r[0].type+"* %"+iterator.reg_id+", align "+r[0].align,true);
	append(("%" + genVarLabel() + " = icmp sle " + r[1].type + " %" + (var_label-1) + ", %" + max), true);
	append(("br i1 %" + var_label + ", label %for_body." + flow_label + ", label %for_end." + flow_label), true);
	
	append("for_incr." + flow_label + ":", true);
	append("%"+genVarLabel()+" = load "+r[0].type+" , "+r[0].type+"* %"+iterator.reg_id+", align "+r[0].align,true);
	append("%"+genVarLabel()+" = add "+r[0].type+" %"+(var_label-1)+", 1",true);
	append("store "+r[0].type+" %"+var_label+", "+r[0].type+"* %"+iterator.reg_id,true);
	append("br label %for_cond." + flow_label, true);

	append(("for_body." + flow_label + ":"), true);
:} statements{:
	append("br label %for_incr." + flow_label, true);
    append("for_end." + flow_label + ":", true);
	flow_label--;
	
:} END;


for_range ::= val:x COL val:y {:
	RESULT = new TypeVar[2];
	RESULT[0] = x;
	RESULT[1] = y;
:} 
| ID:x {:
	TypeVar r = new TypeVar();
	append("%"+r.reg_id+" = "+"alloca i32, "+"align 4",true);
	append("store i32 0"+", i32* %"+r.reg_id,true);
	RESULT[0] = r;
	RESULT[1] = symbolTable.get(x);
:}  ; 

//Print instruction
print_instr ::= print_keyw:nl RO STRING:x RC{:
	CreateString(nl,x);
:} 
| print_keyw:nl RO val:x RC {:
	
	if(!x.value.matches("\\d+"))
	{
		x.value = "$"+x.value;
	}
	CreateString(nl, x.value);
:}  
| print_keyw:nl RO dest_var:x RC
{:
	String s = new String("\\00");
	if(nl)
		s = "\\0A" + s;
	s = "%d"+s;
	Integer length = s.length()-(nl?4:2);
	append("%"+genVarLabel()+" = load "+x.type+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);	
	parser.stringDef.add("@.str." + genStrLabel() + " = private constant [" + length + " x i8] c\"" + s + "\", align 1");
	append(("%" + genVarLabel() + " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([" + length + " x i8], [" + length + " x i8]* @.str." + str_label + ", i32 0, i32 0), i32 %"+(var_label-1)+")"), true);


:}
| print_keyw RO signed_op RC
| print_keyw RO funct_call RC
| print_keyw error {:pSynWarning("Error in print instruction.");:}
;

print_keyw ::= PRINT {:RESULT = false;:}| PRINTLN{:RESULT = true;:};

ret_instr ::= RET operand:x{:
	retType = x.type; 
	append("%"+genVarLabel()+" = load "+x.type+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);	
	append("ret "+x.type +" %"+var_label,true);
:}| RET MINUS operand
| RET signed_op:x{:
	retType = x.type; 
	append("%"+genVarLabel()+" = load "+x.type+", "+x.type+"* %"+x.reg_id+", align "+x.align,true);	
	append("ret %"+var_label,true);
:};