default: clean scanner parser

	javac *.java

scanner:
	jflex --skel skeleton.nested scanner.jflex
	
parser:
	java java_cup.Main parser.cup
	
clean:

	rm -fr parser.java scanner.java sym.java
	rm -vfr *.class
	rm -vfr *.*~
	
init:
	mkdir source build
	
run:
	java Main hello.go

new: default run
