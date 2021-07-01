declare i32 @printf(i8*, ...)
@.str.0 = private constant [52 x i8] c"Number must be a positive integer greater than zero\00", align 1
@.str.1 = private constant [50 x i8] c"The Armstrong numbers in between 1 to 500 are : \0A\00", align 1
@.str.2 = private constant [7 x i8] c" %.0f \00", align 1

@remainder = global double 0.0, align 8
@i = global double 0.0, align 8

define double @Math.pow(double, double ) {
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
ret double %17

}
define double @Math.ceilingSqrt(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = load double, double* %2, align 8
%4 = fcmp oeq double %3, 0.0
%5 = load double, double* %2, align 8
%6 = fcmp oeq double %5, 1.0
%7 = and i1 %4, %6
br i1 %7, label %if.body.2, label %if.else.2
if.body.2:
%8 = load double, double* %2, align 8
ret double %8
br label %if.else.2
if.else.2:
%10 = alloca double, align 8
store double 1.0, double* %10, align 8
%11 = alloca double, align 8
store double 1.0, double* %11, align 8
br label %for.cond.3
for.cond.3:
%12 = load double, double* %11, align 8
%13 = load double, double* %2, align 8
%14 = fcmp olt double %12, %13
br i1 %14, label %for.body.3, label %for.exit.3
for.body.3:
%15 = load double, double* %10, align 8
%16 = fadd double %15, 1.0
store double %16, double* %10, align 8
%17 = load double, double* %10, align 8
%18 = load double, double* %10, align 8
%19 = fmul double %17, %18
store double %19, double* %11, align 8
br label %for.cond.3
for.exit.3:
%20 = load double, double* %10, align 8
ret double %20

}
define double @Math.floor(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = alloca double, align 8
store double 0.0, double* %3, align 8
store double 0.0, double* %3, align 8
br label %for.cond.4
for.cond.4:
%4 = load double, double* %3, align 8
%5 = load double, double* %2, align 8
%6 = fcmp ole double %4, %5
br i1 %6, label %for.body.4, label %for.exit.4
for.inc.4:
%7 = load double, double* %3, align 8
%8 = fadd double %7, 1.0
store double %8, double* %3, align 8
br label %for.cond.4
for.body.4:
%9 = load double, double* %3, align 8
store double %9, double* %3, align 8
br label %for.inc.4
for.exit.4:
%10 = load double, double* %3, align 8
%11 = fsub double %10, 1.0
ret double %11

}
define double @Math.remainder(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = alloca double, align 8
store double 0.0, double* %5, align 8
br label %for.cond.5
for.cond.5:
%6 = load double, double* %5, align 8
%7 = load double, double* %3, align 8
%8 = fcmp ole double %6, %7
br i1 %8, label %for.body.5, label %for.exit.5
for.body.5:
%9 = load double, double* %5, align 8
%10 = load double, double* %4, align 8
%11 = fadd double %9, %10
store double %11, double* %5, align 8
br label %for.cond.5
for.exit.5:
%12 = load double, double* %5, align 8
%13 = load double, double* %4, align 8
%14 = fsub double %12, %13
%15 = load double, double* %3, align 8
%16 = fsub double %15, %14
%17 = alloca double, align 8
store double %16, double* %17, align 8
%18 = load double, double* %17, align 8
ret double %18

}
define double @Math.isPrime(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = load double, double* %2, align 8
%4 = fcmp ole double %3, 0.0
br i1 %4, label %if.body.6, label %if.else.6
if.body.6:
%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str.0, i32 0, i32 0))
ret double -1.0
br label %if.else.6
if.else.6:
%7 = load double, double* %2, align 8
%8 = fcmp oeq double %7, 1.0
br i1 %8, label %if.body.7, label %if.else.7
if.body.7:
ret double 1.0
br label %if.else.7
if.else.7:
%10 = alloca double, align 8
store double 0.0, double* %10, align 8
%11 = load double, double* %2, align 8
%12 = fsub double %11, 1.0
store double %12, double* %10, align 8
br label %for.cond.8
for.cond.8:
%13 = load double, double* %10, align 8
%14 = fcmp ogt double %13, 2.0
br i1 %14, label %for.body.8, label %for.exit.8
for.inc.8:
%15 = load double, double* %10, align 8
%16 = fadd double %15, -1.0
store double %16, double* %10, align 8
br label %for.cond.8
for.body.8:
%17 = load double, double* %2, align 8
%18 = load double, double* %10, align 8
%19 = call double @Math.remainder(double %17, double %18)
%20 = fcmp oeq double %19, 0.0
%21 = load double, double* %10, align 8
%22 = fcmp ogt double %21, 1.0
%23 = and i1 %20, %22
br i1 %23, label %if.body.9, label %if.else.9
if.body.9:
ret double 0.0
br label %if.else.9
if.else.9:
br label %for.inc.8
for.exit.8:
ret double 1.0

}
define double @check_armstrong(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = alloca double, align 8
store double 0.0, double* %3, align 8
%4 = alloca double, align 8
store double 0.0, double* %4, align 8
%5 = alloca double, align 8
%6 = load double, double* %2, align 8
store double %6, double* %5, align 8
%7 = alloca double, align 8
store double 0.0, double* %7, align 8
br label %for.cond.10
for.cond.10:
%8 = load double, double* %5, align 8
%9 = fcmp one double %8, 0.0
br i1 %9, label %for.body.10, label %for.exit.10
for.body.10:
%10 = load double, double* %3, align 8
%11 = fadd double %10, 1.0
store double %11, double* %3, align 8
%12 = load double, double* %5, align 8
%13 = fdiv double %12, 10.0
%14 = call double @Math.floor(double %13)
store double %14, double* %5, align 8
br label %for.cond.10
for.exit.10:
%15 = load double, double* %2, align 8
store double %15, double* %5, align 8
br label %for.cond.11
for.cond.11:
%16 = load double, double* %5, align 8
%17 = fcmp one double %16, 0.0
br i1 %17, label %for.body.11, label %for.exit.11
for.body.11:
%18 = load double, double* %5, align 8
%19 = call double @Math.remainder(double %18, double 10.0)
store double %19, double* @remainder, align 8
%20 = load double, double* @remainder, align 8
%21 = load double, double* %3, align 8
%22 = call double @Math.pow(double %20, double %21)
%23 = load double, double* %4, align 8
%24 = fadd double %23, %22
store double %24, double* %4, align 8
%25 = load double, double* %5, align 8
%26 = fdiv double %25, 10.0
%27 = call double @Math.floor(double %26)
store double %27, double* %5, align 8
br label %for.cond.11
for.exit.11:
%28 = load double, double* %2, align 8
%29 = load double, double* %4, align 8
%30 = fcmp oeq double %28, %29
br i1 %30, label %if.body.12, label %if.else.12
if.body.12:
store double 1.0, double* %7, align 8
br label %if.exit.12
if.else.12:
store double 0.0, double* %7, align 8
br label %if.exit.12
if.exit.12:
%31 = load double, double* %7, align 8
ret double %31

}

define void @main(){
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([50 x i8], [50 x i8]* @.str.1, i32 0, i32 0))
store double 0.0, double* @i, align 8
br label %for.cond.13
for.cond.13:
%2 = load double, double* @i, align 8
%3 = fcmp olt double %2, 10000.0
br i1 %3, label %for.body.13, label %for.exit.13
for.inc.13:
%4 = load double, double* @i, align 8
%5 = fadd double %4, 1.0
store double %5, double* @i, align 8
br label %for.cond.13
for.body.13:
%6 = load double, double* @i, align 8
%7 = call double @check_armstrong(double %6)
%8 = fcmp oeq double %7, 1.0
br i1 %8, label %if.body.14, label %if.else.14
if.body.14:
%9 = load double, double* @i, align 8
%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), double %9)
br label %if.else.14
if.else.14:
br label %for.inc.13
for.exit.13:
ret void
}