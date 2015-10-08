function col_oxwt=fun_col_oxwt(Fo)

MgO_mol=(Fo/100)*(2/3);
FeO_mol=(2/3)-MgO_mol;
SiO2_mol=1/3;
col_mol=[MgO_mol;FeO_mol;SiO2_mol];

FW=[40.3;71.8;60.1];

col_oxwt_un=col_mol.*FW;

col_oxwt=col_oxwt_un/sum(col_oxwt_un);

end