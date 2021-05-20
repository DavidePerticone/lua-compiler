declare i32 @printf(i8*, ...)

@a = global double 5.0, align 8

define double @prova(double, double ) {
%3 = alloca double, align 8
store double %0, double* %3, align 8
%4 = alloca double, align 8
store double %1, double* %4, align 8
%5 = load double, double* %3, align 8
%6 = fcmp oeq double %5, 2.0
br i1 %6, label %if.body.1, label %if.else.1
if.body.1:
store double 2.0, double* %4, align 8
ret double 2.0
br label %if.else.1
if.else.1:
store double 2.0, double* %3, align 8
%8 = load double, double* %3, align 8
%9 = load double, double* %3, align 8
%10 = fmul double %8, %9
ret double %10

}

define void @main(){
store double 5.0, double* @a, align 8
%1 = load double, double* @a, align 8
%2 = fmul double 2.0, %1
%3 = load double, double* @a, align 8
%4 = call double @prova(double %3, double %2)
ret void
}