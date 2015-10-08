function Mg_no=fun_Mg_no_mol(KD,MgO_catmol,FeO_catmol)

%Mg# of melt calculated by mass balance 
Mg_no=(KD*(MgO_catmol/FeO_catmol))/(KD*(MgO_catmol/FeO_catmol)+1);

end