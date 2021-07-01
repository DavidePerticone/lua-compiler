declare i32 @printf(i8*, ...)
@.str.0 = private constant [6 x i8] c"WORKS\00", align 1



define void @main(){
%1 = fcmp oeq double 126.0, 1.0
%2 = icmp eq i32 0, 1
%3 = xor i1 %2, true
%4 = and i1 %1, %3
%5 = and i1 1, 1
br i1 %5, label %if.body.1, label %if.else.1
if.body.1:
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.0, i32 0, i32 0))
br label %if.else.1
if.else.1:
ret void
}