declare i32 @printf(i8*, ...)
@.str.0 = private constant [38 x i8] c" First 20 terms of Fibonacci series:\0A\00", align 1
@.str.1 = private constant [11 x i8] c"Next term:\00", align 1
@.str.2 = private constant [7 x i8] c" %.0f \00", align 1
@.str.3 = private constant [2 x i8] c"\0A\00", align 1

@first_term = global double 0.0, align 8
@second_term = global double 1.0, align 8
@count = global double 20.0, align 8
@i = global double 0.0, align 8
@next_term = global double 0.0, align 8


define void @main(){
store double 0.0, double* @first_term, align 8
store double 1.0, double* @second_term, align 8
store double 20.0, double* @count, align 8
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.0, i32 0, i32 0))
store double 0.0, double* @i, align 8
br label %for.cond.1
for.cond.1:
%2 = load double, double* @i, align 8
%3 = load double, double* @count, align 8
%4 = fcmp olt double %2, %3
br i1 %4, label %for.body.1, label %for.exit.1
for.inc.1:
%5 = load double, double* @i, align 8
%6 = fadd double %5, 1.0
store double %6, double* @i, align 8
br label %for.cond.1
for.body.1:
%7 = load double, double* @i, align 8
%8 = fcmp ole double %7, 1.0
br i1 %8, label %if.body.2, label %if.else.2
if.body.2:
%9 = load double, double* @i, align 8
store double %9, double* @next_term, align 8
br label %if.exit.2
if.else.2:
%10 = load double, double* @first_term, align 8
%11 = load double, double* @second_term, align 8
%12 = fadd double %10, %11
store double %12, double* @next_term, align 8
%13 = load double, double* @second_term, align 8
store double %13, double* @first_term, align 8
%14 = load double, double* @next_term, align 8
store double %14, double* @second_term, align 8
br label %if.exit.2
if.exit.2:
%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
%16 = load double, double* @next_term, align 8
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %16)
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
br label %for.inc.1
for.exit.1:
ret void
}