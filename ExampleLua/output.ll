declare i32 @printf(i8*, ...)
@.str.0 = private constant [2 x i8] c"\0A\00", align 1
@.str.1 = private constant [4 x i8] c"   \00", align 1
@.str.2 = private constant [2 x i8] c" \00", align 1
@.str.3 = private constant [2 x i8] c"|\00", align 1
@.str.4 = private constant [2 x i8] c"^\00", align 1
@.str.5 = private constant [3 x i8] c"\0A \00", align 1
@.str.6 = private constant [10 x i8] c"My stack\0A\00", align 1
@.str.7 = private constant [22 x i8] c"---------------------\00", align 1
@.str.8 = private constant [3 x i8] c"\0A \00", align 1
@.str.9 = private constant [6 x i8] c"%.0f \00", align 1
@.str.10 = private constant [3 x i8] c"\0A \00", align 1
@.str.11 = private constant [22 x i8] c"---------------------\00", align 1
@.str.12 = private constant [3 x i8] c"\0A \00", align 1
@.str.13 = private constant [14 x i8] c"Stack is full\00", align 1
@.str.14 = private constant [15 x i8] c"Stack is empty\00", align 1
@.str.15 = private constant [2 x i8] c"\0A\00", align 1
@.str.16 = private constant [10 x i8] c"Triangle\0A\00", align 1
@.str.17 = private constant [6 x i8] c"%.0f \00", align 1
@.str.18 = private constant [2 x i8] c"\0A\00", align 1
@.str.19 = private constant [2 x i8] c"\0A\00", align 1
@.str.20 = private constant [10 x i8] c"Unsorted\0A\00", align 1
@.str.21 = private constant [6 x i8] c"%.0f \00", align 1
@.str.22 = private constant [2 x i8] c"\0A\00", align 1
@.str.23 = private constant [2 x i8] c"\0A\00", align 1
@.str.24 = private constant [8 x i8] c"Sorted\0A\00", align 1
@.str.25 = private constant [6 x i8] c"%.0f \00", align 1
@.str.26 = private constant [2 x i8] c"\0A\00", align 1

@stack = global [10x double] zeroinitializer, align 16
@size = global double 10.0, align 8
@full = global double 0.0, align 8
@a = global double 0.0, align 8
@l = global double 0.0, align 8
@i = global double 0.0, align 8
@k = global double 0.0, align 8
@v = global [10x double] zeroinitializer, align 16
@swapped = global double 1.0, align 8
@temp = global double 0.0, align 8

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
define double @stack.signalTOS(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = alloca double, align 8
store double 0.0, double* %5, align 8
store double 9.0, double* @size, align 8
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.0, i32 0, i32 0))
br label %for.cond.4
for.cond.4:
%7 = load double, double* %5, align 8
%8 = load double, double* %3, align 8
%9 = fcmp olt double %7, %8
br i1 %9, label %for.body.4, label %for.exit.4
for.body.4:
%10 = alloca double, align 8
store double 0.0, double* %10, align 8
%11 = load double, double* %5, align 8
%12 = fadd double %11, 1.0
store double %12, double* %5, align 8
%13 = load double, double* %3, align 8
%14 = fsub double %13, 1.0
%15 = load double, double* %5, align 8
%16 = fcmp one double %15, %14
br i1 %16, label %if.body.5, label %if.else.5
if.body.5:
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0))
br label %if.exit.5
if.else.5:
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
%19 = load double, double* %4, align 8
%20 = fcmp oeq double %19, 1.0
br i1 %20, label %if.body.6, label %if.else.6
if.body.6:
%21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
br label %if.exit.6
if.else.6:
%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
br label %if.exit.6
if.exit.6:
br label %if.exit.5
if.exit.5:
br label %for.cond.4
for.exit.4:
ret double 1.0

}
define double @stack.printStack() {
%1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.5, i32 0, i32 0))
%2 = alloca double, align 8
store double 0.0, double* %2, align 8
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0))
%4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i32 0, i32 0))
%5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.8, i32 0, i32 0))
br label %for.body.7
for.body.7:
%6 = load double, double* %2, align 8
%7 = fptosi double %6 to i32
%8 = getelementptr inbounds [10x double], [10x double]*@stack, i32 0, i32 %7
%9 = load double, double* %8, align 8
%10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i32 0, i32 0), double %9)
%11 = load double, double* %2, align 8
%12 = fadd double %11, 1.0
store double %12, double* %2, align 8
br label %for.cond.7
for.cond.7:
%13 = load double, double* %2, align 8
%14 = load double, double* @full, align 8
%15 = fcmp olt double %13, %14
br i1 %15, label %for.body.7, label %for.exit.7
for.exit.7:
%16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.10, i32 0, i32 0))
%17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.11, i32 0, i32 0))
%18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.12, i32 0, i32 0))
ret double 0.0

}
define double @stack.pushStack(double ) {
%2 = alloca double, align 8
store double %0, double* %2, align 8
%3 = load double, double* @full, align 8
%4 = load double, double* @size, align 8
%5 = fcmp oeq double %3, %4
br i1 %5, label %if.body.8, label %if.else.8
if.body.8:
%6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.13, i32 0, i32 0))
ret double -1.0
br label %if.else.8
if.else.8:
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
define double @stack.popStack() {
%1 = load double, double* @full, align 8
%2 = fcmp oeq double %1, 0.0
br i1 %2, label %if.body.9, label %if.else.9
if.body.9:
%3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.14, i32 0, i32 0))
ret double -1.0
br label %if.else.9
if.else.9:
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
%11 = call double @Math.ceilingSqrt(double 63.0)
%12 = call double @stack.pushStack(double %11)
%13 = call double @Math.pow(double 2.0, double 4.0)
%14 = call double @stack.pushStack(double %13)
%15 = call double @Math.pow(double 2.5, double 8.0)
%16 = call double @stack.pushStack(double %15)
%17 = call double @Math.ceilingSqrt(double 63.5)
%18 = call double @stack.pushStack(double %17)
%19 = call double @stack.printStack()
%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.15, i32 0, i32 0))
store double 0.0, double* @a, align 8
%21 = call double @stack.popStack()
store double %21, double* @l, align 8
%22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.16, i32 0, i32 0))
store double 0.0, double* @i, align 8
br label %for.cond.10
for.cond.10:
%23 = load double, double* @i, align 8
%24 = load double, double* @l, align 8
%25 = fcmp ole double %23, %24
br i1 %25, label %for.body.10, label %for.exit.10
for.inc.10:
%26 = load double, double* @i, align 8
%27 = fadd double %26, 1.0
store double %27, double* @i, align 8
br label %for.cond.10
for.body.10:
store double 0.0, double* @k, align 8
br label %for.cond.11
for.cond.11:
%28 = load double, double* @k, align 8
%29 = load double, double* @i, align 8
%30 = fcmp ole double %28, %29
br i1 %30, label %for.body.11, label %for.exit.11
for.inc.11:
%31 = load double, double* @k, align 8
%32 = fadd double %31, 1.0
store double %32, double* @k, align 8
br label %for.cond.11
for.body.11:
%33 = load double, double* @a, align 8
%34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.17, i32 0, i32 0), double %33)
%35 = load double, double* @a, align 8
%36 = fadd double %35, 1.0
store double %36, double* @a, align 8
br label %for.inc.11
for.exit.11:
store double 0.0, double* @a, align 8
%37 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.18, i32 0, i32 0))
br label %for.inc.10
for.exit.10:
%38 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 0
store double 3.0, double* %38, align 8
%39 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 1
store double 1.0, double* %39, align 8
%40 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 2
store double 2.0, double* %40, align 8
%41 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 3
store double 5.0, double* %41, align 8
%42 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 4
store double 3.0, double* %42, align 8
%43 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 5
store double 6.0, double* %43, align 8
%44 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 6
store double 8.0, double* %44, align 8
%45 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 7
store double 2.0, double* %45, align 8
%46 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 8
store double 1.0, double* %46, align 8
%47 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 9
store double 9.0, double* %47, align 8
store double 10.0, double* @size, align 8
store double 1.0, double* @swapped, align 8
%48 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.19, i32 0, i32 0))
%49 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.20, i32 0, i32 0))
store double 0.0, double* @a, align 8
br label %for.cond.12
for.cond.12:
%50 = load double, double* @a, align 8
%51 = load double, double* @size, align 8
%52 = fcmp one double %50, %51
br i1 %52, label %for.body.12, label %for.exit.12
for.body.12:
%53 = load double, double* @a, align 8
%54 = fptosi double %53 to i32
%55 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %54
%56 = load double, double* %55, align 8
%57 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.21, i32 0, i32 0), double %56)
%58 = load double, double* @a, align 8
%59 = fadd double %58, 1.0
store double %59, double* @a, align 8
br label %for.cond.12
for.exit.12:
%60 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.22, i32 0, i32 0))
%61 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.23, i32 0, i32 0))
br label %for.cond.13
for.cond.13:
%62 = load double, double* @swapped, align 8
%63 = fcmp oeq double %62, 1.0
br i1 %63, label %for.body.13, label %for.exit.13
for.body.13:
store double 0.0, double* @swapped, align 8
store double 0.0, double* @i, align 8
br label %for.cond.14
for.cond.14:
%64 = load double, double* @i, align 8
%65 = load double, double* @size, align 8
%66 = fcmp olt double %64, %65
br i1 %66, label %for.body.14, label %for.exit.14
for.inc.14:
%67 = load double, double* @i, align 8
%68 = fadd double %67, 1.0
store double %68, double* @i, align 8
br label %for.cond.14
for.body.14:
%69 = load double, double* @i, align 8
%70 = fsub double %69, 1.0
%71 = fptosi double %70 to i32
%72 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %71
%73 = load double, double* @i, align 8
%74 = fptosi double %73 to i32
%75 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %74
%76 = load double, double* %72, align 8
%77 = load double, double* %75, align 8
%78 = fcmp ogt double %76, %77
br i1 %78, label %if.body.15, label %if.else.15
if.body.15:
%79 = load double, double* @i, align 8
%80 = fptosi double %79 to i32
%81 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %80
%82 = load double, double* %81, align 8
store double %82, double* @temp, align 8
%83 = load double, double* @i, align 8
%84 = fptosi double %83 to i32
%85 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %84
%86 = load double, double* @i, align 8
%87 = fsub double %86, 1.0
%88 = fptosi double %87 to i32
%89 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %88
%90 = load double, double* %89, align 8
store double %90, double* %85, align 8
%91 = load double, double* @i, align 8
%92 = fsub double %91, 1.0
%93 = fptosi double %92 to i32
%94 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %93
%95 = load double, double* @temp, align 8
store double %95, double* %94, align 8
store double 1.0, double* @swapped, align 8
br label %if.else.15
if.else.15:
br label %for.inc.14
for.exit.14:
br label %for.cond.13
for.exit.13:
%96 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.24, i32 0, i32 0))
store double 0.0, double* @a, align 8
br label %for.cond.16
for.cond.16:
%97 = load double, double* @a, align 8
%98 = load double, double* @size, align 8
%99 = fcmp one double %97, %98
br i1 %99, label %for.body.16, label %for.exit.16
for.body.16:
%100 = load double, double* @a, align 8
%101 = fptosi double %100 to i32
%102 = getelementptr inbounds [10x double], [10x double]*@v, i32 0, i32 %101
%103 = load double, double* %102, align 8
%104 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.25, i32 0, i32 0), double %103)
%105 = load double, double* @a, align 8
%106 = fadd double %105, 1.0
store double %106, double* @a, align 8
br label %for.cond.16
for.exit.16:
%107 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.26, i32 0, i32 0))
ret void
}