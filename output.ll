@a = global double 0.0, align 8
define void @main(){
br label %for.cond.1
for.cond.1:
%1 = load double, double* @a, align 8
%2 = fcmp olt double %1, 5.0
br i1 %2, label %for.body.1, label %for.exit.1
for.body.1:
%3 = load double, double* @a, align 8
%4 = fcmp oeq double %3, 2.0
br i1 %4, label %if.body.2, label %if.else.2
if.body.2:
%5 = load double, double* @a, align 8
%6 = fadd double %5, 1.0
store double %6, double* @a, align 8
br label %if.else.2
if.else.2:
%7 = load double, double* @a, align 8
%8 = fadd double %7, 1.0
store double %8, double* @a, align 8
br label %for.cond.1
for.exit.1:
ret void
}