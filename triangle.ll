declare i32 @printf(i8*, ...)
@.str.1 = private constant [4 x i8] c" %d\00", align 1
@.str.2 = private constant [2 x i8] c"\0A\00", align 1
define void @main(){
%1 = alloca i32, align 4
store i32 1, i32* %1
%2 = alloca i32, align 4
store i32 1, i32* %2
%3 = alloca i32, align 4
store i32 10, i32* %3
%4 = load i32 , i32* %2, align 4
%5 = load i32 , i32* %3, align 4
%6 = alloca i32, align 4
store i32 %4, i32* %6
br label %for_cond.1
for_cond.1:
%7 = load i32 , i32* %6, align 4
%8 = icmp sle i32 %7, %5
br i1 %8, label %for_body.1, label %for_end.1
for_incr.1:
%9 = load i32 , i32* %6, align 4
%10 = add i32 %9, 1
store i32 %10, i32* %6
br label %for_cond.1
for_body.1:
%11 = alloca i32, align 4
store i32 1, i32* %11
%12 = load i32 , i32* %11, align 4
%13 = load i32 , i32* %6, align 4
%14 = alloca i32, align 4
store i32 %12, i32* %14
br label %for_cond.2
for_cond.2:
%15 = load i32 , i32* %14, align 4
%16 = icmp sle i32 %15, %13
br i1 %16, label %for_body.2, label %for_end.2
for_incr.2:
%17 = load i32 , i32* %14, align 4
%18 = add i32 %17, 1
store i32 %18, i32* %14
br label %for_cond.2
for_body.2:
%19 = load i32, i32* %1, align 4
%20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %19)
%21 = alloca i32, align 4
store i32 1, i32* %21
%22 = load i32, i32* %1, align 4
%23 = load i32, i32* %21, align 4
%24 = add i32 %22, %23
store i32 %24, i32* %1
br label %for_incr.2
for_end.2:
%25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0))
br label %for_incr.1
for_end.1:
ret void
}