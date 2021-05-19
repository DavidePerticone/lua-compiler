default: clean scanner parser

	javac *.java

scanner:
	jflex go_scanner.jflex
	
parser:
	java java_cup.Main -expect 3 -parser parser go_parser.cup
	
clean:

	rm -fr parser.java scanner.java sym.java
	rm -vfr *.class
	rm -vfr *.*~
	
init:
	mkdir source build
	
run:
	java Main hello.go

new: default run
