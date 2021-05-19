import java_cup.runtime.*;

%%

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


/*  A Lua identifier is a name used to identify a variable, 
    function, or any other user-defined item.
*/

/*  Lua does not allow punctuation characters such as @, $, 
    and % within identifiers. Lua is a case sensitive programming
    language. 
*/

id = [A-Za-z_][A-Za-z0-9_]*
number = ([1-9][0-9]*|0) | (([0-9]+\.[0-9]*) | ([0-9]*\.[0-9]+)) (e|E('+'|'-')?[0-9]+)?
string = \"~\"
nl = \r|\n|\r\n|" "

%%



"do"       {return symbol(sym.DO);}
"for"      {return symbol(sym.FOR);}
"if"       {return symbol(sym.IF);}
"else"     {return symbol(sym.ELSE);}
"elseif"   {return symbol(sym.ELSEIF);}
"end"      {return symbol(sym.END);}
"local"    {return symbol(sym.LOCAL);}
/*

"in"    {return symbol(sym.IN);}







*/
"nil"    {return symbol(sym.NIL);}
"print"     {return symbol(sym.PRINT);}
"return"    {return symbol(sym.RETURN);}
"function"    {return symbol(sym.FUNCTION);}
"then"    {return symbol(sym.THEN);}
"while"    {return symbol(sym.WHILE);}
"until"    {return symbol(sym.UNTIL);}
"repeat"    {return symbol(sym.REPEAT);}

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
"and"     {return symbol(sym.AND);}
"or"     {return symbol(sym.OR);}
"not"     {return symbol(sym.NOT);}
"^"     {return symbol(sym.HAT);}
"~="     {return symbol(sym.NOTEQ);}
"["     {return symbol(sym.SO);}
"]"     {return symbol(sym.SC);}
","     {return symbol(sym.CM);}


{id}      {return symbol(sym.ID, yytext());}
{string}  {return symbol(sym.STRING, yytext());}
{number}  {return symbol(sym.NUMBER, new Double(yytext()));}


{nl} {;}

. {System.out.println("SCANNER ERROR: "+yytext());}