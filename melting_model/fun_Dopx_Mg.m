%%
function Dopx_Mg=fun_Dopx_Mg(MgO_molar, FeO_molar)

Dopx_Mg=((2/4)-0.129.*(FeO_molar/100))./(0.264.*(FeO_molar/100)+(MgO_molar/100));

end
%%