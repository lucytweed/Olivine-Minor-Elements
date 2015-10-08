%%
function Dol_Mg=fun_Dol_Mg(MgO_molar, FeO_molar)

Dol_Mg=(2/3-0.027.*(FeO_molar/100))./(0.299.*(FeO_molar/100)+(MgO_molar/100));

end
%%