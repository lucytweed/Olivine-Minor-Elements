function [bulk_oxwt_pd,bulk_catmol_pd,Xun_pd,X_pd,n_pd,...
    r_pd,KD_pd,res_catmol_pd,Mgno_pd,Mgno_mol_pd,c_oxwt_pd,c_oxmol_pd,...
    c_catwt_pd,c_catmol_pd,c_dF_pd,sumc_dF_pd,Cun_oxwt_pd,C_oxwt_pd,C_oxmol_pd,...
    C_catwt_pd,C_catmol_pd,Mgno_mol_ptav_pd,C_F_pd,avCun_oxwt_pd,avC_oxwt_pd,Dol_Mg_pd,Dopx_Mg_pd,...
    Dol_Mg_ptav_pd,Fo_pd,col_catmol_pd,col_catwt_pd,col_oxmol_pd,col_oxwt_pd,...
    Fo_ptav_pd,Col_catmol_pd,Col_catwt_pd,Col_oxmol_pd,Col_oxwt_pd,...
    D_pd,D_shallow_pd,D_ptav_pd,X_D_pd,bulkD_pd,ctl_pd,ctl_dF_pd,Ctl_pd,...
    Ctl_F_pd,avCtl_pd,Tbasliq_pd,Tbasliq_ptav_pd,cts_pd,ctol_pd,Ctol_pd,avCtol_pd]=pd_variables(P)
%%

%Residual mineralogy unnormalised
Xun_pd=zeros(length(P),6);
%normalised
X_pd=zeros(length(P),6);
%Melting reactions
n_pd=zeros(length(P),7);
%Subsolidus reactions
r_pd=zeros(length(P),6);

%Bulk peridotite composition: KLB1 from Takahashi, 1986
%           [SiO2, TiO2, Cr2O3, Al2O3, FeO, MgO, CaO, MnO, NiO, Na2O, K2O]
%           [ 1  ,  2  ,  3   ,  4   ,  5 ,  6 ,  7 , 8  ,  9 , 10  , 11 ]
%Bulk comp in oxide wt%
bulk_oxwt_pd=[44.50,0.16,0.31,3.59,8.10,39.22,3.44,0.12,0.25,0.30,0.02];
%Bulk comp in cation mol%
bulk_catmol_pd=fun_catmol_bulk(bulk_oxwt_pd);

%Fe-Mg exchange coefficients (KD)
KD_pd=zeros(length(P),7);

res_catmol_pd=zeros(length(P),2);

%Mg# of instantaneous melt
Mgno_pd=zeros(length(P),1);
Mgno_mol_pd=zeros(length(P),1);
%Instantaneous melt major element composition: In oxide wt%
c_oxwt_pd=zeros(length(P),7);
%In oxide mol%
c_oxmol_pd=zeros(length(P),7);
%In cation mol%
c_catmol_pd=zeros(length(P),7);
%In cation wt%
c_catwt_pd=zeros(length(P),7);

%Point average melt major element composition: Product of c and dF for
%calculating pt av composition
c_dF_pd=zeros(length(P),7);
sumc_dF_pd=zeros(1,7);
%In oxide wt%
Cun_oxwt_pd=zeros(length(P),7);
C_oxwt_pd=zeros(length(P),7);
%In oxide mol%
C_oxmol_pd=zeros(length(P),7);
%In cation mol%
C_catmol_pd=zeros(length(P),7);
%In cation wt%
C_catwt_pd=zeros(length(P),7);
%Mg#
Mgno_mol_ptav_pd=zeros(length(P),1);

%Point and depth average melt major element composition: Product of C and F
%for calculating average composition
C_F_pd=zeros(length(P),7);
%In oxide wt%
avCun_oxwt_pd=zeros(1,7);
avC_oxwt_pd=zeros(1,7);

%Fe-Mg concentration of olivine
%Dmg
Dol_Mg_pd=zeros(length(P),1);
Dopx_Mg_pd=zeros(length(P),1);
Dol_Mg_ptav_pd=zeros(length(P),1);

%Fe&Mg concentration of ol
%1) In equilibrium with instantaneous melts
Fo_pd=zeros(length(P),1);
col_catmol_pd=zeros(length(P),3);
col_catwt_pd=zeros(length(P),3);
col_oxmol_pd=zeros(length(P),3);
col_oxwt_pd=zeros(length(P),3);
%2) In equilibrium with point average melts
Fo_ptav_pd=zeros(length(P),1);
Col_catmol_pd=zeros(length(P),3);
Col_catwt_pd=zeros(length(P),3);
Col_oxmol_pd=zeros(length(P),3);
Col_oxwt_pd=zeros(length(P),3);

% Partition coefficients
%     Ni  Mn   V  Cr  Ti  Co  Sc  Zn
% ol   -   -   -   -   -  -   -   -
% opx  -   -   -   -   -  -   -   -
% cpx  -   -   -   -   -  -   -   -
% plag -   -   -   -   -  -   -   -
% sp   -   -   -   -   -  -   -   -
% gt   -   -   -   -   -  -   -   -

D_pd=zeros(length(P),6,8);
D_shallow_pd=zeros(length(P),8);
D_ptav_pd=zeros(length(P),8);
X_D_pd=zeros(length(P),6,8);
bulkD_pd=zeros(length(P),8);

%Minor elements: Ni  Mn  V  Cr  Ti  Co  Sc  Zn
%Incremental melt trace element composition
ctl_pd=zeros(length(P),8);
%Point average melt trace element composition
ctl_dF_pd=zeros(length(P),1);
Ctl_pd=zeros(length(P),8);
%Point and depth average melt trace element composition
Ctl_F_pd=zeros(length(P),8);
avCtl_pd=zeros(1,8);

%Temperature of shallow basalt liquidus
Tbasliq_pd=zeros(length(P),1);
Tbasliq_ptav_pd=zeros(length(P),1);

%Solid residue trace element composition
cts_pd=zeros(length(P),8);

%Trace element composition of 1st olivines to xtallise at base of crust from:
%1) incremental fractional melts
ctol_pd=zeros(length(P),8);
%2) point average fractional melts
Ctol_pd=zeros(length(P),8);
%3) point and depth average fractional melt
avCtol_pd=zeros(1,8);

end
    