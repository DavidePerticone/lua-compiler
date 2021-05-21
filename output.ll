declare i32 @printf(i8*, ...)
@.str.0 = private constant [7 x i8] c" %.0f \00", align 1
@.str.1 = private constant [2 x i8] c"\0A\00", align 1


define double @pow(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = alloca double, align 8
%6 = load double, double* %3, align 8
store double %6, double* %5, align 8
%7 = alloca double, align 8
store double 0.0, double* %7, align 8
store double 0.0, double* %7, align 8
br label %for.cond.1
for.cond.1:
%8 = load double, double* %4, align 8
%9 = fsub double %8, 1.0
%10 = load double, double* %7, align 8
%11 = fcmp olt double %10, %9
br i1 %11, label %for.body.1, label %for.exit.1
for.inc.1:
%12 = load double, double* %7, align 8
%13 = fadd double %12, 1.0
store double %13, double* %7, align 8
br label %for.cond.1
for.body.1:
%14 = load double, double* %5, align 8
%15 = load double, double* %3, align 8
%16 = fmul double %14, %15
store double %16, double* %5, align 8
br label %for.inc.1
for.exit.1:
%17 = load double, double* %5, align 8
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.0, i32 0, i32 0), double %17)
%19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
%20 = load double, double* %5, align 8
ret double %20

}

define void @main(){
%1 = call double @pow(double 2.0, double 5.0)
ret void
}