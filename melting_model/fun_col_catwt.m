function col_catwt=fun_col_catwt(Fo)

Mg_mol=(Fo/100)*(2/3);
Fe_mol=(2/3)-Mg_mol;
Si_mol=1/3;
col_mol=[Mg_mol;Fe_mol;Si_mol];

FW=[24.3;55.8;28.1];

col_catwt_un=col_mol.*FW;

col_catwt=100*(col_catwt_un/sum(col_catwt_un));

end