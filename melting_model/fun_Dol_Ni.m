%%
function Dol_Ni=fun_Dol_Ni(T,c_oxmol,c_oxwt,KD)

r=c_oxmol(4)/(KD*c_oxmol(3));
Mg_no=r/(r+1);

%olivine normalising constant
MgO_mol=Mg_no*(2/3);
FeO_mol=(2/3)-MgO_mol;
SiO2_mol=1/3;
col_oxmol=[MgO_mol,FeO_mol,SiO2_mol];
FW_ol=[40.3,71.8,60.1];
col_oxwt_un=col_oxmol.*FW_ol;
col_oxwt=100*col_oxwt_un/sum(col_oxwt_un);
col_oxmol_un=col_oxwt./FW_ol;

%melt normalising constant
FW_l=[30.04,102,71.8,40.3,56.1,62,159.7];
c_oxmol_un=c_oxwt./FW_l;

Dol_Ni_molar=exp((4338/(T+273))-1.956-log(c_oxmol(4)./(100*Mg_no)));

Dol_Ni=Dol_Ni_molar.*(sum(col_oxmol_un)*(MgO_mol+FeO_mol))./sum(c_oxmol_un);

end
%%