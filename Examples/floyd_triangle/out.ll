declare i32 @printf(i8*, ...)
@.str.0 = private constant [10 x i8] c"Triangle\0A\00", align 1
@.str.1 = private constant [6 x i8] c"%.0f \00", align 1
@.str.2 = private constant [2 x i8] c"\0A\00", align 1

@a = global double 0.0, align 8
@l = global double 15.0, align 8
@i = global double 0.0, align 8
@k = global double 0.0, align 8


define void @main(){
store double 0.0, double* @a, align 8
store double 15.0, double* @l, align 8
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.0, i32 0, i32 0))
store double 0.0, double* @i, align 8
br label %for.cond.1
for.cond.1:
%2 = load double, double* @i, align 8
%3 = load double, double* @l, align 8
%4 = fcmp ole double %2, %3
br i1 %4, label %for.body.1, label %for.exit.1
for.inc.1:
%5 = load double, double* @i, align 8
%6 = fadd double %5, 1.0
store double %6, double* @i, align 8
br label %for.cond.1
for.body.1:
store double 0.0, double* @k, align 8
br label %for.cond.2
for.cond.2:
%7 = load double, double* @k, align 8
%8 = load double, double* @i, align 8
%9 = fcmp ole double %7, %8
br i1 %9, label %for.body.2, label %for.exit.2
for.inc.2:
%10 = load double, double* @k, align 8
%11 = fadd double %10, 1.0
store double %11, double* @k, align 8
br label %for.cond.2
for.body.2:
%12 = load double, double* @a, align 8
%13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), double %12)
%14 = load double, double* @a, align 8
%15 = fadd double %14, 1.0
store double %15, double* @a, align 8
br label %for.inc.2
for.exit.2:
store double 0.0, double* @a, align 8
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
br label %for.inc.1
for.exit.1:
ret void
}