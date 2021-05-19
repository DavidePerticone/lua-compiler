@a = global double 5.0, align 8
@b = global double 6.0, align 8
define void @main(){
%1 = load double, double* @b, align 8
store double %1, double* @a, align 8
store double 5.0, double* @a, align 8
ret void
}