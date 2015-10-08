function Dol=fun_Dol(T,c_oxmol,c_oxwt,KD_ol,Dol_Mg)

Dol=[fun_Dol_Ni(T,c_oxmol,c_oxwt,KD_ol),...
    fun_Dol_Mn(Dol_Mg),fun_Dol_V(),fun_Dol_Cr(Dol_Mg),...
    fun_Dol_Ti(),fun_Dol_Co(Dol_Mg),fun_Dol_Sc(Dol_Mg),fun_Dol_Zn()];

end