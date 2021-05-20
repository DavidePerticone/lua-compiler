@a = global double 5.0, align 8
define void @main(){
br label %for.cond.1
for.cond.1:
%1 = load double, double* @a, align 8
%2 = fcmp oeq double %1, 2.0
br i1 %2, label %for.body.1, label %for.exit.1
for.body.1:
%3 = load double, double* @a, align 8
%4 = fcmp oeq double %3, 2.0
br i1 %4, label %if.body.2, label %if.else.2
if.body.2:
%5 = load double, double* @a, align 8
%6 = fcmp oeq double %5, 2.0
br i1 %6, label %if.body.3, label %if.else.3
if.body.3:
store double 1.0, double* @a, align 8
%7 = load double, double* @a, align 8
%8 = fcmp oeq double %7, 2.0
br i1 %8, label %if.body.4, label %if.else.4
if.body.4:
store double 1.0, double* @a, align 8
br label %if.else.4
if.else.4:
br label %if.else.3
if.else.3:
%9 = load double, double* @a, align 8
%10 = fcmp oeq double %9, 2.0
br i1 %10, label %if.body.5, label %if.else.5
if.body.5:
store double 1.0, double* @a, align 8
br label %if.else.5
if.else.5:
store double 0.0, double* @a, align 8
br label %if.else.2
if.else.2:
br label %for.cond.1
for.exit.1:
ret void
}