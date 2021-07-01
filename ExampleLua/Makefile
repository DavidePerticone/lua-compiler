default: clean scanner parser

	javac *.java
	

scanner:
	jflex --skel skeleton.nested scanner.jflex
	
parser:
	java java_cup.Main parser.cup
	
clean:

	rm -fr parser.java scanner.java sym.java Yylex.java
	rm -vfr *.class
	rm -vfr *.*~
	
init:
	mkdir source build
	
run:
	java Main main.lua

new: default run
