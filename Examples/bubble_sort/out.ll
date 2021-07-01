declare i32 @printf(i8*, ...)
@.str.0 = private constant [2 x i8] c"\0A\00", align 1
@.str.1 = private constant [10 x i8] c"Unsorted\0A\00", align 1
@.str.2 = private constant [6 x i8] c"%.0f \00", align 1
@.str.3 = private constant [2 x i8] c"\0A\00", align 1
@.str.4 = private constant [2 x i8] c"\0A\00", align 1
@.str.5 = private constant [8 x i8] c"Sorted\0A\00", align 1
@.str.6 = private constant [6 x i8] c"%.0f \00", align 1
@.str.7 = private constant [2 x i8] c"\0A\00", align 1

@v = global [10 x double] zeroinitializer, align 16
@size = global double 10.0, align 8
@swapped = global double 1.0, align 8
@a = global double 0.0, align 8
@i = global double 0.0, align 8
@temp = global double 0.0, align 8


define void @main(){
%1 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 0
store double 3.0, double* %1, align 8
%2 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 1
store double 1.0, double* %2, align 8
%3 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 2
store double 2.0, double* %3, align 8
%4 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 3
store double 5.0, double* %4, align 8
%5 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 4
store double 3.0, double* %5, align 8
%6 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 5
store double 6.0, double* %6, align 8
%7 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 6
store double 8.0, double* %7, align 8
%8 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 7
store double 2.0, double* %8, align 8
%9 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 8
store double 1.0, double* %9, align 8
%10 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 9
store double 9.0, double* %10, align 8
store double 10.0, double* @size, align 8
store double 1.0, double* @swapped, align 8
%11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.0, i32 0, i32 0))
%12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0))
store double 0.0, double* @a, align 8
br label %for.cond.1
for.cond.1:
%13 = load double, double* @a, align 8
%14 = load double, double* @size, align 8
%15 = fcmp one double %13, %14
br i1 %15, label %for.body.1, label %for.exit.1
for.body.1:
%16 = load double, double* @a, align 8
%17 = fptosi double %16 to i32
%18 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %17
%19 = load double, double* %18, align 8
%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i32 0, i32 0), double %19)
%21 = load double, double* @a, align 8
%22 = fadd double %21, 1.0
store double %22, double* @a, align 8
br label %for.cond.1
for.exit.1:
%23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.3, i32 0, i32 0))
%24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0))
br label %for.cond.2
for.cond.2:
%25 = load double, double* @swapped, align 8
%26 = fcmp oeq double %25, 1.0
br i1 %26, label %for.body.2, label %for.exit.2
for.body.2:
store double 0.0, double* @swapped, align 8
store double 0.0, double* @i, align 8
br label %for.cond.3
for.cond.3:
%27 = load double, double* @i, align 8
%28 = load double, double* @size, align 8
%29 = fcmp olt double %27, %28
br i1 %29, label %for.body.3, label %for.exit.3
for.inc.3:
%30 = load double, double* @i, align 8
%31 = fadd double %30, 1.0
store double %31, double* @i, align 8
br label %for.cond.3
for.body.3:
%32 = load double, double* @i, align 8
%33 = fsub double %32, 1.0
%34 = fptosi double %33 to i32
%35 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %34
%36 = load double, double* @i, align 8
%37 = fptosi double %36 to i32
%38 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %37
%39 = load double, double* %35, align 8
%40 = load double, double* %38, align 8
%41 = fcmp ogt double %39, %40
br i1 %41, label %if.body.4, label %if.else.4
if.body.4:
%42 = load double, double* @i, align 8
%43 = fptosi double %42 to i32
%44 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %43
%45 = load double, double* %44, align 8
store double %45, double* @temp, align 8
%46 = load double, double* @i, align 8
%47 = fptosi double %46 to i32
%48 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %47
%49 = load double, double* @i, align 8
%50 = fsub double %49, 1.0
%51 = fptosi double %50 to i32
%52 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %51
%53 = load double, double* %52, align 8
store double %53, double* %48, align 8
%54 = load double, double* @i, align 8
%55 = fsub double %54, 1.0
%56 = fptosi double %55 to i32
%57 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %56
%58 = load double, double* @temp, align 8
store double %58, double* %57, align 8
store double 1.0, double* @swapped, align 8
br label %if.else.4
if.else.4:
br label %for.inc.3
for.exit.3:
br label %for.cond.2
for.exit.2:
%59 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.5, i32 0, i32 0))
store double 0.0, double* @a, align 8
br label %for.cond.5
for.cond.5:
%60 = load double, double* @a, align 8
%61 = load double, double* @size, align 8
%62 = fcmp one double %60, %61
br i1 %62, label %for.body.5, label %for.exit.5
for.body.5:
%63 = load double, double* @a, align 8
%64 = fptosi double %63 to i32
%65 = getelementptr inbounds [10 x double], [10 x double]*@v, i32 0, i32 %64
%66 = load double, double* %65, align 8
%67 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.6, i32 0, i32 0), double %66)
%68 = load double, double* @a, align 8
%69 = fadd double %68, 1.0
store double %69, double* @a, align 8
br label %for.cond.5
for.exit.5:
%70 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i32 0, i32 0))
ret void
}