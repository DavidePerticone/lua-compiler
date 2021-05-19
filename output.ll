@a = global double 5.0, align 8
@d = global double 2.0, align 8
define void @main(){
%1 = load double, double* @d, align 8
%2 = load double, double* @d, align 8
%3 = fmul double %1, %2
%4 = load double, double* @a, align 8
%5 = fmul double %3, %4
%6 = load double, double* @a, align 8
%7 = fadd double %5, %6
%8 = load double, double* @a, align 8
%9 = fadd double %7, %8
%10 = load double, double* @d, align 8
%11 = fsub double %9, %10
%12 = fadd double %11, 2.0
store double %12, double* @d, align 8
ret void
}