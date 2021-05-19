@a = global double -3.0, align 8
@b = global double -5.0, align 8
@c = global double 5.0, align 8
define void @main(){
store double 2.0, double* @a, align 8
%1 = load double, double* @a, align 8
store double %1, double* @b, align 8
%2 = load double, double* @a, align 8
store double %2, double* @c, align 8
ret void
}