function Mg_no=fun_Mg_no(KD,MgO_catmol,FeO_catmol)

%Mg# of melt as mass ratio 
Mg_no=(KD*40.3*(MgO_catmol/FeO_catmol))/(KD*40.3*(MgO_catmol/FeO_catmol)+71.8);

end

