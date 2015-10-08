%%
function col=fun_col_catmol(Fo)

Mg_mol=(Fo/100)*(2/3);
Fe_mol=(2/3)-Mg_mol;
Si_mol=1/3;

col=[Mg_mol;Fe_mol;Si_mol];

end
%%