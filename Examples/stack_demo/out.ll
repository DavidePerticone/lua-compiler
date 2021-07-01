declare i32 @printf(i8*, ...)
@.str.0 = private constant [52 x i8] c"Number must be a positive integer greater than zero\00", align 1
@.str.1 = private constant [2 x i8] c"\0A\00", align 1
@.str.2 = private constant [4 x i8] c"   \00", align 1
@.str.3 = private constant [2 x i8] c" \00", align 1
@.str.4 = private constant [2 x i8] c"|\00", align 1
@.str.5 = private constant [2 x i8] c"^\00", align 1
@.str.6 = private constant [3 x i8] c"\0A \00", align 1
@.str.7 = private constant [10 x i8] c"My stack\0A\00", align 1
@.str.8 = private constant [22 x i8] c"---------------------\00", align 1
@.str.9 = private constant [3 x i8] c"\0A \00", align 1
@.str.10 = private constant [6 x i8] c"%.0f \00", align 1
@.str.11 = private constant [3 x i8] c"\0A \00", align 1
@.str.12 = private constant [22 x i8] c"---------------------\00", align 1
@.str.13 = private constant [3 x i8] c"\0A \00", align 1
@.str.14 = private constant [14 x i8] c"Stack is full\00", align 1
@.str.15 = private constant [15 x i8] c"Stack is empty\00", align 1
@.str.16 = private constant [72 x i8] c" This is an example of using to external files: Math.lua and stack.lua\0A\00", align 1
@.str.17 = private constant [2 x i8] c"\0A\00", align 1
@.str.18 = private constant [28 x i8] c" 2 elevated to the fourth: \00", align 1
@.str.19 = private constant [7 x i8] c" %.0f \00", align 1
@.str.20 = private constant [2 x i8] c"\0A\00", align 1
@.str.21 = private constant [2 x i8] c"\0A\00", align 1
@.str.22 = private constant [20 x i8] c" Popped value %.0f\0A\00", align 1
@.str.23 = private constant [2 x i8] c"\0A\00", align 1

@stack = global [10 x double] zeroinitializer, align 16
@size = global double 10.0, align 8
@full = global double 0.0, align 8
@val = global double 0.0, align 8
@a = global double 0.0, align 8
@l = global double 0.0, align 8

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
define double @stack.signalTOS(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = alloca double, align 8
store double 0.0, double* %5, align 8
store double 9.0, double* @size, align 8
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
br label %for.cond.10
for.cond.10:
%7 = load double, double* %5, align 8
%8 = load double, double* %3, align 8
%9 = fcmp olt double %7, %8
br i1 %9, label %for.body.10, label %for.exit.10
for.body.10:
%10 = alloca double, align 8
store double 0.0, double* %10, align 8
%11 = load double, double* %5, align 8
%12 = fadd double %11, 1.0
store double %12, double* %5, align 8
%13 = load double, double* %3, align 8
%14 = fsub double %13, 1.0
%15 = load double, double* %5, align 8
%16 = fcmp one double %15, %14
br i1 %16, label %if.body.11, label %if.else.11
if.body.11:
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
br label %if.exit.11
if.else.11:
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
%19 = load double, double* %4, align 8
%20 = fcmp oeq double %19, 1.0
br i1 %20, label %if.body.12, label %if.else.12
if.body.12:
%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
br label %if.exit.12
if.else.12:
%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
br label %if.exit.12
if.exit.12:
br label %if.exit.11
if.exit.11:
br label %for.cond.10
for.exit.10:
ret double 1.0

}
define double @stack.printStack() {
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.6, i32 0, i32 0))
%2 = alloca double, align 8
store double 0.0, double* %2, align 8
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i32 0, i32 0))
%4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.8, i32 0, i32 0))
%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.9, i32 0, i32 0))
br label %for.body.13
for.body.13:
%6 = load double, double* %2, align 8
%7 = fptosi double %6 to i32
%8 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 %7
%9 = load double, double* %8, align 8
%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.10, i32 0, i32 0), double %9)
%11 = load double, double* %2, align 8
%12 = fadd double %11, 1.0
store double %12, double* %2, align 8
br label %for.cond.13
for.cond.13:
%13 = load double, double* %2, align 8
%14 = load double, double* @full, align 8
%15 = fcmp olt double %13, %14
br i1 %15, label %for.body.13, label %for.exit.13
for.exit.13:
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.11, i32 0, i32 0))
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.12, i32 0, i32 0))
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.13, i32 0, i32 0))
ret double 0.0

}
define double @stack.pushStack(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = load double, double* @full, align 8
%4 = load double, double* @size, align 8
%5 = fcmp oeq double %3, %4
br i1 %5, label %if.body.14, label %if.else.14
if.body.14:
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.14, i32 0, i32 0))
ret double -1.0
br label %if.else.14
if.else.14:
%8 = load double, double* @full, align 8
%9 = fptosi double %8 to i32
%10 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 %9
%11 = load double, double* %2, align 8
store double %11, double* %10, align 8
%12 = load double, double* @full, align 8
%13 = fadd double %12, 1.0
store double %13, double* @full, align 8
ret double 1.0

}
define double @stack.popStack() {
%1 = load double, double* @full, align 8
%2 = fcmp oeq double %1, 0.0
br i1 %2, label %if.body.15, label %if.else.15
if.body.15:
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.15, i32 0, i32 0))
ret double -1.0
br label %if.else.15
if.else.15:
%5 = load double, double* @full, align 8
%6 = fsub double %5, 1.0
store double %6, double* @full, align 8
%7 = load double, double* @full, align 8
%8 = fptosi double %7 to i32
%9 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 %8
%10 = alloca double, align 8
%11 = load double, double* %9, align 8
store double %11, double* %10, align 8
%12 = load double, double* %10, align 8
ret double %12

}

define void @main(){
%1 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 0
store double 0.0, double* %1, align 8
%2 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 1
store double 0.0, double* %2, align 8
%3 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 2
store double 0.0, double* %3, align 8
%4 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 3
store double 0.0, double* %4, align 8
%5 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 4
store double 0.0, double* %5, align 8
%6 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 5
store double 0.0, double* %6, align 8
%7 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 6
store double 0.0, double* %7, align 8
%8 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 7
store double 0.0, double* %8, align 8
%9 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 8
store double 0.0, double* %9, align 8
%10 = getelementptr inbounds [10 x double], [10 x double]*@stack, i32 0, i32 9
store double 0.0, double* %10, align 8
store double 10.0, double* @size, align 8
store double 0.0, double* @full, align 8
%11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([72 x i8], [72 x i8]* @.str.16, i32 0, i32 0))
%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.17, i32 0, i32 0))
%13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.18, i32 0, i32 0))
%14 = call double @Math.pow(double 2.0, double 4.0)
store double %14, double* @val, align 8
%15 = load double, double* @val, align 8
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.19, i32 0, i32 0), double %15)
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.20, i32 0, i32 0))
%18 = call double @Math.ceilingSqrt(double 63.0)
%19 = call double @stack.pushStack(double %18)
%20 = call double @Math.pow(double 2.0, double 4.0)
%21 = call double @stack.pushStack(double %20)
%22 = call double @Math.pow(double 2.5, double 8.0)
%23 = call double @stack.pushStack(double %22)
%24 = call double @Math.ceilingSqrt(double 63.5)
%25 = call double @stack.pushStack(double %24)
%26 = call double @stack.printStack()
%27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.21, i32 0, i32 0))
store double 0.0, double* @a, align 8
%28 = call double @stack.popStack()
store double %28, double* @l, align 8
%29 = load double, double* @l, align 8
%30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.22, i32 0, i32 0), double %29)
%31 = call double @stack.printStack()
%32 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.23, i32 0, i32 0))
ret void
}