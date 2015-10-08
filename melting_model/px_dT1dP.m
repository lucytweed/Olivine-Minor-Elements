function dT1dP=px_dT1dP(P,F)

% dT1dP=1241/10-(70368744177664*((64*P)/5-331/10)*(((4486521133158577*F)/...
%     35184372088832+8628/5)^(1/2)-2077/50))/4486521133158577-(47*P)/5;

% dT1dP=1e-9*(1241/10 - (4503599627370496*((64*P)/5 - 331/10)*(((2871373525221489*F)...
%     /2251799813685248 + 2157/12500)^(1/2) - 2077/5000))/2871373525221489 - (47*P)/5);

dT1dP=1e-9*((((52917295621603328*P)/5 - 698620892195848192/5)*((717843156125391*F)/562949953421312 + 777128361476111/4503599627370496)^(1/2))/717843156125391 - (37167029048223778*P)/35050935357685105 - (((124974889659531264*P)/5 - 884957326778302464/5)*((717843156125391*F)/562949953421312 + 777128361476111/4503599627370496)^(1/2))/717843156125391 + 3593921127443883239/35050935357685105);

end