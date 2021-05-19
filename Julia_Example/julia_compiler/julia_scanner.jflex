import java_cup.runtime.*;
import java.io.*; 
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
integer =  ([1-9][0-9]*|0)
double = (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?

%%
"("     {return symbol(sym.RO);}
")"     {return symbol(sym.RC);}
"="     {return symbol(sym.EQU);}
"+"     {return symbol(sym.PLUS);}
"-"     {return symbol(sym.MINUS);}
"*"     {return symbol(sym.STAR);}
"/"     {return symbol(sym.DIV);}
"<"     {return symbol(sym.MIN);}
">"     {return symbol(sym.MAJ);}
"<="    {return symbol(sym.MINEQU);}
">="    {return symbol(sym.MAJEQU);}
"=="    {return symbol(sym.EQEQ);}
"!="    {return symbol(sym.NEQ);}
"&&"     {return symbol(sym.AND);}
"||"     {return symbol(sym.OR);}
"!"     {return symbol(sym.NOT);}

"["     {return symbol(sym.SO);}
"]"     {return symbol(sym.SC);}





"else"    {return symbol(sym.ELSE);}
"end"     {return symbol(sym.END);}
"for"    {return symbol(sym.FOR);}
"function"    {return symbol(sym.FUNCT);}
"if"      {return symbol(sym.IF);}
"in"      {return symbol(sym.IN);}
"print"   {return symbol(sym.PRINT);}
"println"   {return symbol(sym.PRINTLN);}
"return"  {return symbol(sym.RET);}
"while"   {return symbol(sym.WHILE);}
","       {return symbol(sym.C);}
":"       {return symbol(sym.COL);}
";"       {return symbol(sym.SEMIC);}

{id}      {return symbol(sym.ID, yytext());}

{integer} {return symbol(sym.INT, new Integer(yytext()));}

{double}  {return symbol(sym.DOUBLE, new Double(yytext()));}


"#".*      {;}
\" ~  \"      {return symbol(sym.STRING, yytext());}

{ws}|{nl}       {;}

. {System.out.println("SCANNER ERROR: "+yytext());}