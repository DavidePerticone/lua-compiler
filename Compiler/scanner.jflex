import java_cup.runtime.*;
import java.io.FileReader;
import java.nio.file.*;
import java.io.FileNotFoundException;
%%

%unicode
%cup
%line
%column
%xstate INCL DELETENR

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
	
  }
%}


id = [A-Za-z_][A-Za-z0-9_]*
number = ([1-9][0-9]*|0) | (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?
string = \"~\"
nl = \r|\n|\r\n|" "
n2 = \r|\n|\r\n
comment = "--"~{n2}|"--[["~"--]]"
FILE = \"[A-Za-z_][A-Za-z0-9_\.]*\"
%%

{comment} { ; }  

"require" {         System.out.println(yytext());
                    yybegin(INCL); 
                    return symbol(sym.REQUIRE);
          }

<INCL>[" "\t]* {;}

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

<DELETENR>[\t\n\r]* {yybegin(YYINITIAL);}

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
"}"               {return symbol(sym.BC);}
"="               {return symbol(sym.EQ);}
"+"               {return symbol(sym.PLUS);}
"-"               {return symbol(sym.MINUS);}
"*"               {return symbol(sym.STAR);}
"/"               {return symbol(sym.DIV);}
"<"               {return symbol(sym.MIN);}
">"               {return symbol(sym.MAJ);}
"<="              {return symbol(sym.MIN_EQ);}
">="              {return symbol(sym.MAJ_EQ);}
"and"             {return symbol(sym.AND);}
"or"              {return symbol(sym.OR);}
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