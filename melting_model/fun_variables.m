function [bulk_oxwt_pd,bulk_catmol_pd,Xun_pd,X_pd,n_pd,...
    r_pd,KD_pd,res_catmol_pd,Mgno_pd,Mgno_mol_pd,c_oxwt_pd,c_oxmol_pd,...
    c_catwt_pd,c_catmol_pd,c_dF_pd,sumc_dF_pd,Cun_oxwt_pd,C_oxwt_pd,C_oxmol_pd,...
    C_catwt_pd,C_catmol_pd,Mgno_mol_ptav_pd,C_F_pd,avCun_oxwt_pd,avC_oxwt_pd,Dol_Mg_pd,Dopx_Mg_pd,...
    Dol_Mg_ptav_pd,Fo_pd,col_catmol_pd,col_catwt_pd,col_oxmol_pd,col_oxwt_pd,...
    Fo_ptav_pd,Col_catmol_pd,Col_catwt_pd,Col_oxmol_pd,Col_oxwt_pd,...
    D_pd,D_shallow_pd,D_ptav_pd,X_D_pd,bulkD_pd,ctl_pd,ctl_dF_pd,Ctl_pd,...
    Ctl_F_pd,avCtl_pd,Tbasliq_pd,Tbasliq_ptav_pd,cts_pd,ctol_pd,Ctol_pd,avCtol_pd]=fun_variables()

P=(0:0.1:6)';

[bulk_oxwt_pd,bulk_catmol_pd,Xun_pd,X_pd,n_pd,...
    r_pd,KD_pd,res_catmol_pd,Mgno_pd,Mgno_mol_pd,c_oxwt_pd,c_oxmol_pd,...
    c_catwt_pd,c_catmol_pd,c_dF_pd,sumc_dF_pd,Cun_oxwt_pd,C_oxwt_pd,C_oxmol_pd,...
    C_catwt_pd,C_catmol_pd,Mgno_mol_ptav_pd,C_F_pd,avCun_oxwt_pd,avC_oxwt_pd,Dol_Mg_pd,Dopx_Mg_pd,...
    Dol_Mg_ptav_pd,Fo_pd,col_catmol_pd,col_catwt_pd,col_oxmol_pd,col_oxwt_pd,...
    Fo_ptav_pd,Col_catmol_pd,Col_catwt_pd,Col_oxmol_pd,Col_oxwt_pd,...
    D_pd,D_shallow_pd,D_ptav_pd,X_D_pd,bulkD_pd,ctl_pd,ctl_dF_pd,Ctl_pd,...
    Ctl_F_pd,avCtl_pd,Tbasliq_pd,Tbasliq_ptav_pd,cts_pd,ctol_pd,Ctol_pd,avCtol_pd]=pd_variables(P);

end