declare i32 @printf(i8*, ...)
@.str.0 = private constant [6 x i8] c"%.0f \00", align 1
@.str.1 = private constant [2 x i8] c"\0A\00", align 1

@a = global double 0.0, align 8
@l = global double 20.0, align 8
@i = global double 0.0, align 8
@k = global double 0.0, align 8


define void @main(){
store double 0.0, double* @a, align 8
store double 20.0, double* @l, align 8
store double 0.0, double* @i, align 8
br label %for.cond.1
for.cond.1:
%1 = load double, double* @i, align 8
%2 = load double, double* @l, align 8
%3 = fcmp ole double %1, %2
br i1 %3, label %for.body.1, label %for.exit.1
for.inc.1:
%4 = load double, double* @i, align 8
%5 = fadd double %4, 1.0
store double %5, double* @i, align 8
br label %for.cond.1
for.body.1:
store double 0.0, double* @k, align 8
br label %for.cond.2
for.cond.2:
%6 = load double, double* @k, align 8
%7 = load double, double* @i, align 8
%8 = fcmp ole double %6, %7
br i1 %8, label %for.body.2, label %for.exit.2
for.inc.2:
%9 = load double, double* @k, align 8
%10 = fadd double %9, 1.0
store double %10, double* @k, align 8
br label %for.cond.2
for.body.2:
%11 = load double, double* @a, align 8
%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.0, i32 0, i32 0), double %11)
%13 = load double, double* @a, align 8
%14 = fadd double %13, 1.0
store double %14, double* @a, align 8
br label %for.inc.2
for.exit.2:
store double 0.0, double* @a, align 8
%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
br label %for.inc.1
for.exit.1:
ret void
}