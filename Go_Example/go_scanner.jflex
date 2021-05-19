import java_cup.runtime.*;

%%
%class scanner
%unicode
%cup
%line
%column

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
	
  }
%}

nl = \r|\n|\r\n
ws = [ \t]
id = [A-Za-z_][A-Za-z0-9_]*
integer = ([1-9][0-9]*|0)
double = (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?
package = package[ ]+{id}
import = import [ ]+\"{id}\"|import[ ]+\(~\)
comment = "//"~{nl}|"/*"~"*/"
string = \"~\"

%%

"func"     {return symbol(sym.FUNC);}
"return"   {return symbol(sym.RET);}

"fmt.Printf" {return symbol(sym.PRINT);} 

"int"      {return symbol(sym.INT_TYPE);}
"float64"  {return symbol(sym.FLOAT64_TYPE);}
 
"var"      {return symbol(sym.VAR);}
"const"    {return symbol(sym.CONST);}

"for"      {return symbol(sym.FOR);}
"if"       {return symbol(sym.IF);}
"else"     {return symbol(sym.ELSE);}

":"        {return symbol(sym.COL);}

"("     {return symbol(sym.RO);}
")"     {return symbol(sym.RC);}
"{"     {return symbol(sym.BO);}
"}"     {return symbol(sym.BC);}
"="     {return symbol(sym.EQ);}
"+"     {return symbol(sym.PLUS);}
"-"     {return symbol(sym.MINUS);}
"*"     {return symbol(sym.STAR);}
"/"     {return symbol(sym.DIV);}
"<"     {return symbol(sym.MIN);}
">"     {return symbol(sym.MAJ);}
"<="    {return symbol(sym.MIN_EQ);}
">="    {return symbol(sym.MAJ_EQ);}
"&"     {return symbol(sym.AND);}
"|"     {return symbol(sym.OR);}
"^"     {return symbol(sym.XOR);}
"!"     {return symbol(sym.NOT);}

"["     {return symbol(sym.SO);}
"]"     {return symbol(sym.SC);}

","     {return symbol(sym.CM);}
";"     {return symbol(sym.S);}

{id}      {return symbol(sym.ID, yytext());}
{string}  {return symbol(sym.STRING, yytext());}
{integer} {return symbol(sym.INT, new Integer(yytext()));}
{double}  {return symbol(sym.DOUBLE, new Double(yytext()));}

{package}|{import}|{comment}|{ws}|{nl} {;}

. {System.out.println("SCANNER ERROR: "+yytext());}

