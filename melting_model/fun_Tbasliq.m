function Tbasliq=fun_Tbasliq(P,c_oxwt,Mgno_molar)

XMgO=c_oxwt(4);
XFeO=c_oxwt(3);

%Assume [Na2O] and [K2O] in melt constant
XNa2O=c_oxwt(6);
XK2O=0.1;

Tbasliq=815.3+265.5.*Mgno_molar+15.37*XMgO+8.61*XFeO+6.646*(XNa2O+XK2O)+39.16.*P;

end
