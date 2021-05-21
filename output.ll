declare i32 @printf(i8*, ...)
@.str.0 = private constant [2 x i8] c"\0A\00", align 1
@.str.1 = private constant [2 x i8] c"-\00", align 1
@.str.2 = private constant [4 x i8] c"   \00", align 1
@.str.3 = private constant [2 x i8] c" \00", align 1
@.str.4 = private constant [2 x i8] c"|\00", align 1
@.str.5 = private constant [2 x i8] c"^\00", align 1
@.str.6 = private constant [3 x i8] c"\0A \00", align 1
@.str.7 = private constant [22 x i8] c"---------------------\00", align 1
@.str.8 = private constant [3 x i8] c"\0A \00", align 1
@.str.9 = private constant [6 x i8] c"%.0f \00", align 1
@.str.10 = private constant [3 x i8] c"\0A \00", align 1
@.str.11 = private constant [22 x i8] c"---------------------\00", align 1
@.str.12 = private constant [3 x i8] c"\0A \00", align 1
@.str.13 = private constant [14 x i8] c"Stack is full\00", align 1
@.str.14 = private constant [15 x i8] c"Stack is empty\00", align 1

@stack = global [10x double] zeroinitializer, align 16
@size = global double 10.0, align 8
@full = global double 0.0, align 8

define double @signalTOS(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = alloca double, align 8
store double 0.0, double* %5, align 8
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.0, i32 0, i32 0))
br label %for.cond.1
for.cond.1:
%7 = load double, double* %5, align 8
%8 = load double, double* %3, align 8
%9 = fcmp olt double %7, %8
br i1 %9, label %for.body.1, label %for.exit.1
for.body.1:
%10 = alloca double, align 8
store double 0.0, double* %10, align 8
br label %for.cond.2
for.cond.2:
%11 = load double, double* %10, align 8
%12 = fcmp olt double %11, 10.0
br i1 %12, label %for.body.2, label %for.exit.2
for.body.2:
%13 = load double, double* %10, align 8
%14 = fadd double %13, 1.0
store double %14, double* %10, align 8
%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
br label %for.cond.2
for.exit.2:
%16 = load double, double* %5, align 8
%17 = fadd double %16, 1.0
store double %17, double* %5, align 8
%18 = load double, double* %3, align 8
%19 = fsub double %18, 1.0
%20 = load double, double* %5, align 8
%21 = fcmp one double %20, %19
br i1 %21, label %if.body.3, label %if.else.3
if.body.3:
%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0))
br label %if.exit.3
if.else.3:
%23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
%24 = load double, double* %4, align 8
%25 = fcmp oeq double %24, 1.0
br i1 %25, label %if.body.4, label %if.else.4
if.body.4:
%26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
br label %if.exit.4
if.else.4:
%27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0))
br label %if.exit.4
if.exit.4:
br label %if.exit.3
if.exit.3:
br label %for.cond.1
for.exit.1:
ret double 0.0

}
define double @printStack() {
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.6, i32 0, i32 0))
%2 = alloca double, align 8
store double 0.0, double* %2, align 8
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i32 0, i32 0))
%4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.8, i32 0, i32 0))
br label %for.body.5
for.body.5:
%5 = load double, double* %2, align 8
%6 = fptosi double %5 to i32
%7 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 %6
%8 = load double, double* %7, align 8
%9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0), double %8)
%10 = load double, double* %2, align 8
%11 = fadd double %10, 1.0
store double %11, double* %2, align 8
br label %for.cond.5
for.cond.5:
%12 = load double, double* %2, align 8
%13 = load double, double* @full, align 8
%14 = fcmp olt double %12, %13
br i1 %14, label %for.body.5, label %for.exit.5
for.exit.5:
%15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.10, i32 0, i32 0))
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.11, i32 0, i32 0))
%17 = load double, double* @full, align 8
%18 = call double @signalTOS(double %17, double 0.0)
%19 = load double, double* @full, align 8
%20 = call double @signalTOS(double %19, double 1.0)
%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.12, i32 0, i32 0))
ret double 0.0

}
define double @pushStack(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = load double, double* @full, align 8
%4 = load double, double* @size, align 8
%5 = fcmp oeq double %3, %4
br i1 %5, label %if.body.6, label %if.else.6
if.body.6:
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.13, i32 0, i32 0))
ret double -1.0
br label %if.else.6
if.else.6:
%8 = load double, double* @full, align 8
%9 = fptosi double %8 to i32
%10 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 %9
%11 = load double, double* %2, align 8
store double %11, double* %10, align 8
%12 = load double, double* @full, align 8
%13 = fadd double %12, 1.0
store double %13, double* @full, align 8
ret double 1.0

}
define double @popStack() {
%1 = load double, double* @full, align 8
%2 = fcmp oeq double %1, 0.0
br i1 %2, label %if.body.7, label %if.else.7
if.body.7:
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.14, i32 0, i32 0))
ret double -1.0
br label %if.else.7
if.else.7:
%5 = load double, double* @full, align 8
%6 = fsub double %5, 1.0
store double %6, double* @full, align 8
%7 = load double, double* @full, align 8
%8 = fptosi double %7 to i32
%9 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 %8
%10 = alloca double, align 8
%11 = load double, double* %9, align 8
store double %11, double* %10, align 8
%12 = load double, double* %10, align 8
ret double %12

}

define void @main(){
%1 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 0
store double 0.0, double* %1, align 8
%2 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 1
store double 0.0, double* %2, align 8
%3 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 2
store double 0.0, double* %3, align 8
%4 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 3
store double 0.0, double* %4, align 8
%5 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 4
store double 0.0, double* %5, align 8
%6 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 5
store double 0.0, double* %6, align 8
%7 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 6
store double 0.0, double* %7, align 8
%8 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 7
store double 0.0, double* %8, align 8
%9 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 8
store double 0.0, double* %9, align 8
%10 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 9
store double 0.0, double* %10, align 8
store double 10.0, double* @size, align 8
store double 0.0, double* @full, align 8
%11 = call double @pushStack(double 1.0)
%12 = call double @pushStack(double 2.0)
%13 = call double @pushStack(double 3.0)
%14 = call double @pushStack(double 4.0)
%15 = call double @printStack()
%16 = call double @popStack()
%17 = call double @printStack()
ret void
}