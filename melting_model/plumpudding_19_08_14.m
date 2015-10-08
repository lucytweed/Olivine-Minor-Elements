function [P,z,T,phi,F,dF,F_pd,dF_pd,F_px,dF_px,Xun_pd,X_pd,n_pd,r_pd,c_oxwt_pd,C_oxwt_pd,avC_oxwt_pd,Mgno_pd]=plumpudding_19_08_14(T0,phi0)

global Tp Cp_pd alpha_pd rho_pd rho_l_pd delS_pd Cp_px alpha_px rho_px ...
    rho_l_px delS_px

Tp=T0;   %potential temperature
Cp_pd=1187;
alpha_pd=30e-6;
rho_pd=3300;
rho_l_pd=2900;
delS_pd=407;
Cp_px=1140;
alpha_px=30e-6;
rho_px=3300;
rho_l_px=2900;
delS_px=380;

h=-0.02;  %step size

P=(6:h:0)';
z=(P*1e9/(10*3300))/1e3; %z=P/rho*g
T=zeros(length(P),1);
T(1)=fun_adiabat(P(1),phi0);

phi=zeros(length(P),1);
phi(1)=phi0;
F=zeros(length(P),1);
dF=zeros(length(P),1);
F_pd=zeros(length(P),1);
F_pd(1)=0.000001;
dF_pd=zeros(length(P),1);
F_px=zeros(length(P),1);
F_px(1)=0.000001;
dF_px=zeros(length(P),1);

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
%Initial trace element composition of unnmelted DMM
cts_pd(1,:)=[2000,1200,79,2500,798,106,16.3,56];

%Trace element composition of 1st olivines to xtallise at base of crust from:
%1) incremental fractional melts
ctol_pd=zeros(length(P),8);
%2) point average fractional melts
Ctol_pd=zeros(length(P),8);
%3) point and depth average fractional melt
avCtol_pd=zeros(1,8);

for i=1:(length(P)-1)
    if T(i)<px_Tsol(P(i+1))
        T(i+1)=fun_adiabat(P(i+1),phi(i));
        F_px(i+1)=F_px(i);
        F_pd(i+1)=F_pd(i);
        
    else if T(i)>px_Tsol(P(i+1)) && T(i)<pd_Tsol(P(i+1))
            l_1 = px_dFdP1cpx(P(i),F_px(i),phi(i));
            l_2 = px_dFdP1cpx(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
            l_3 = px_dFdP1cpx((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
            l_4 = px_dFdP1cpx((P(i)+h),(F_px(i)+l_3*h),phi(i));
            
            j_1 = fun_dTdPpxcpx(P(i),T(i),phi(i));
            j_2 = fun_dTdPpxcpx(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
            j_3 = fun_dTdPpxcpx((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
            j_4 = fun_dTdPpxcpx((P(i)+h),(T(i)+j_3*h),phi(i));
            
            F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
            
            dF_px(i+1)=F_px(i+1)-F_px(i);
            
            F_pd(i+1)=F_pd(i);
            
            dF_pd(i+1)=F_pd(i+1)-F_pd(i);
            
            T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
            
        else if phi(i)==1 && T(i)>px_Tcpx(P(i+1)) && T(i)<px_Tsol(P(i+1))
                l_1 = px_dFdP1(P(i),F_px(i),phi(i));
                l_2 = px_dFdP1(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
                l_3 = px_dFdP1((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
                l_4 = px_dFdP1((P(i)+h),(F_px(i)+l_3*h),phi(i));
                
                j_1 = fun_dTdPpx(P(i),T(i),phi(i));
                j_2 = fun_dTdPpx(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
                j_3 = fun_dTdPpx((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
                j_4 = fun_dTdPpx((P(i)+h),(T(i)+j_3*h),phi(i));
                
                F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
                
                dF_px(i+1)=F_px(i+1)-F_px(i);
                
                F_pd(i+1)=F_pd(i);
                
                dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                
                T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                
            else if T(i)>pd_Tsol(P(i+1)) && T(i)<px_Tcpx(P(i+1)) && T(i)<pd_Tcpx(P(i+1))
                    k_1 = pd_dFdP2cpx2(P(i),F_pd(i),phi(i));
                    k_2 = pd_dFdP2cpx2(P(i)+0.5*h,F_pd(i)+0.5*h*k_1,phi(i));
                    k_3 = pd_dFdP2cpx2((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2),phi(i));
                    k_4 = pd_dFdP2cpx2((P(i)+h),(F_pd(i)+k_3*h),phi(i));
                    
                    l_1 = px_dFdP2cpx2(P(i),F_px(i),phi(i));
                    l_2 = px_dFdP2cpx2(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
                    l_3 = px_dFdP2cpx2((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
                    l_4 = px_dFdP2cpx2((P(i)+h),(F_px(i)+l_3*h),phi(i));
                    
                    j_1 = fun_dTdP2cpx2(P(i),T(i),phi(i));
                    j_2 = fun_dTdP2cpx2(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
                    j_3 = fun_dTdP2cpx2((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
                    j_4 = fun_dTdP2cpx2((P(i)+h),(T(i)+j_3*h),phi(i));
                    
                    F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
                    
                    dF_px(i+1)=F_px(i+1)-F_px(i);
                    
                    F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                    
                    dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                    
                    T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                    
                else if T(i)>pd_Tsol(P(i+1)) && T(i)<px_Tliq(P(i+1)) && T(i)>px_Tcpx(P(i+1)) && T(i)<pd_Tcpx(P(i+1))
                        k_1 = pd_dFdP2cpx(P(i),F_pd(i),phi(i));
                        k_2 = pd_dFdP2cpx(P(i)+0.5*h,F_pd(i)+0.5*h*k_1,phi(i));
                        k_3 = pd_dFdP2cpx((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2),phi(i));
                        k_4 = pd_dFdP2cpx((P(i)+h),(F_pd(i)+k_3*h),phi(i));
                        
                        l_1 = px_dFdP2cpxpd(P(i),F_px(i),phi(i));
                        l_2 = px_dFdP2cpxpd(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
                        l_3 = px_dFdP2cpxpd((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
                        l_4 = px_dFdP2cpxpd((P(i)+h),(F_px(i)+l_3*h),phi(i));
                        
                        j_1 = fun_dTdP2cpxpd(P(i),T(i),phi(i));
                        j_2 = fun_dTdP2cpxpd(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
                        j_3 = fun_dTdP2cpxpd((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
                        j_4 = fun_dTdP2cpxpd((P(i)+h),(T(i)+j_3*h),phi(i));
                        
                        F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
                        
                        dF_px(i+1)=F_px(i+1)-F_px(i);
                        
                        F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                        
                        dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                        
                        T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                        
                    else if T(i)>pd_Tcpx(P(i+1)) && T(i)<px_Tcpx(P(i+1))
                            k_1 = pd_dFdP2cpxpx(P(i),F_pd(i),phi(i));
                            k_2 = pd_dFdP2cpxpx(P(i)+0.5*h,F_pd(i)+0.5*h*k_1,phi(i));
                            k_3 = pd_dFdP2cpxpx((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2),phi(i));
                            k_4 = pd_dFdP2cpxpx((P(i)+h),(F_pd(i)+k_3*h),phi(i));
                            
                            l_1 = px_dFdP2cpx(P(i),F_px(i),phi(i));
                            l_2 = px_dFdP2cpx(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
                            l_3 = px_dFdP2cpx((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
                            l_4 = px_dFdP2cpx((P(i)+h),(F_px(i)+l_3*h),phi(i));
                            
                            j_1 = fun_dTdP2cpxpx(P(i),T(i),phi(i));
                            j_2 = fun_dTdP2cpxpx(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
                            j_3 = fun_dTdP2cpxpx((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
                            j_4 = fun_dTdP2cpxpx((P(i)+h),(T(i)+j_3*h),phi(i));
                            
                            F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
                            
                            dF_px(i+1)=F_px(i+1)-F_px(i);
                            
                            F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                            
                            dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                            
                            T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                            
                        else if T(i)>px_Tcpx(P(i+1)) && T(i)<px_Tliq(P(i+1)) && T(i)>pd_Tcpx(P(i+1)) && T(i)<pd_Tliq(P(i+1))
                                k_1 = pd_dFdP2(P(i),F_pd(i),phi(i));
                                k_2 = pd_dFdP2(P(i)+0.5*h,F_pd(i)+0.5*h*k_1,phi(i));
                                k_3 = pd_dFdP2((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2),phi(i));
                                k_4 = pd_dFdP2((P(i)+h),(F_pd(i)+k_3*h),phi(i));
                                
                                l_1 = px_dFdP2(P(i),F_px(i),phi(i));
                                l_2 = px_dFdP2(P(i)+0.5*h,F_px(i)+0.5*h*l_1,phi(i));
                                l_3 = px_dFdP2((P(i)+0.5*h),(F_px(i)+0.5*h*l_2),phi(i));
                                l_4 = px_dFdP2((P(i)+h),(F_px(i)+l_3*h),phi(i));
                                
                                j_1 = fun_dTdP2(P(i),T(i),phi(i));
                                j_2 = fun_dTdP2(P(i)+0.5*h,T(i)+0.5*h*j_1,phi(i));
                                j_3 = fun_dTdP2((P(i)+0.5*h),(T(i)+0.5*h*j_2),phi(i));
                                j_4 = fun_dTdP2((P(i)+h),(T(i)+j_3*h),phi(i));
                                
                                F_px(i+1)=real(F_px(i)+(1/6)*(l_1+2*l_2+2*l_3+l_4)*h);
                                
                                dF_px(i+1)=F_px(i+1)-F_px(i);
                                
                                F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                                
                                dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                                
                                T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                                
                            else if T(i)>px_Tliq(P(i+1)) && T(i)<pd_Tliq(P(i+1)) && T(i)<pd_Tcpx(P(i+1))
                                    k_1 = pd_dFdP1cpx(P(i),F_pd(i));
                                    k_2 = pd_dFdP1cpx(P(i)+0.5*h,F_pd(i)+0.5*h*k_1);
                                    k_3 = pd_dFdP1cpx((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2));
                                    k_4 = pd_dFdP1cpx((P(i)+h),(F_pd(i)+k_3*h));
                                    
                                    j_1 = fun_dTdPpdcpx(P(i),T(i));
                                    j_2 = fun_dTdPpdcpx(P(i)+0.5*h,T(i)+0.5*h*j_1);
                                    j_3 = fun_dTdPpdcpx((P(i)+0.5*h),(T(i)+0.5*h*j_2));
                                    j_4 = fun_dTdPpdcpx((P(i)+h),(T(i)+j_3*h));
                                    
                                    F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                                    
                                    dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                                    
                                    T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                                    
                                else if T(i)>px_Tliq(P(i+1)) && T(i)<pd_Tliq(P(i+1))
                                        k_1 = pd_dFdP1(P(i),F_pd(i));
                                        k_2 = pd_dFdP1(P(i)+0.5*h,F_pd(i)+0.5*h*k_1);
                                        k_3 = pd_dFdP1((P(i)+0.5*h),(F_pd(i)+0.5*h*k_2));
                                        k_4 = pd_dFdP1((P(i)+h),(F_pd(i)+k_3*h));
                                        
                                        j_1 = fun_dTdPpd(P(i),T(i));
                                        j_2 = fun_dTdPpd(P(i)+0.5*h,T(i)+0.5*h*j_1);
                                        j_3 = fun_dTdPpd((P(i)+0.5*h),(T(i)+0.5*h*j_2));
                                        j_4 = fun_dTdPpd((P(i)+h),(T(i)+j_3*h));
                                        
                                        F_pd(i+1)=real(F_pd(i)+(1/6)*(k_1+2*k_2+2*k_3+k_4)*h);
                                        
                                        dF_pd(i+1)=F_pd(i+1)-F_pd(i);
                                        
                                        T(i+1)=real(T(i)+(1/6)*(j_1+2*j_2+2*j_3+j_4)*h);
                                        
                                    else T(i+1)=T(i);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    
    %phi(i+1)=phi(i)*(1-dF_px(i+1))/(1-phi(i)*dF_px(i+1)-(1-phi(i))*dF_pd(i+1));
    phi(i+1)=phi(i)*(1-dF_px(i+1))/(1-phi(i)*dF_px(i+1)-(1-phi(i))*dF_pd(i+1));
    F(i+1)=phi(i+1)*F_px(i+1)+(1-phi(i+1))*F_pd(i+1);
    dF(i+1)=F(i+1)-F(i);
    
    %%
    %INITIAL MODAL MINERALOGY
    startX_pd=pd_startX(P(1));
    for j=1:6
        X_pd(1,j)=startX_pd(j)./sum(startX_pd(:));
        Xun_pd(1,j)=X_pd(1,j);
    end
    
    %EVOLUTION IN MINERALOGY OF RESIDUE DURING MELTING
    %Melting reaction coefficients
    n_pd(1,:)=pd_melting_coefs(X_pd(1,:),P(1));
    n_pd(i+1,:)=pd_melting_coefs(X_pd(i,:),P(i+1));
    
    %Subsolidus reaction coefficients
    r_pd(1,:)=pd_subsol_coefs(P(1),X_pd(1,:));
    r_pd(i+1,:)=pd_subsol_coefs(P(i+1),X_pd(i,:));

    %Subsolidus+melting reactions
    for j=1:6 %t=1   2   3   4   5  6
              %  ol opx cpx plag sp gt
              
        Xun_pd(i+1,j)=Xun_pd(i,j)+n_pd(i+1,j)*dF_pd(i+1)+r_pd(i+1,j)*h;
        if P(i+1)<pd_Pgt_out()
            Xun_pd(i+1,6)=0;
        end
        if P(i+1)<pd_Psp_out()
            Xun_pd(i+1,5)=0;
        end
       
        %Positivity constraint on modal mineralogy
        if Xun_pd(i+1,j)<=0
            Xun_pd(i+1,j)=0;
        end
    end
    
    for j=1:6
        %Normalised modal mineralogy after melting and subsolidus reactions
        X_pd(i+1,j)=Xun_pd(i+1,j)/sum(Xun_pd(i+1,:));
    end
end

for i=1:length(P)-1
    %MAJOR ELEMENT MELT COMPOSITION
    KD_pd(1,:)=fun_KD(X_pd(1,:));
    Mgno_pd(1)=fun_Mg_no(KD_pd(1,7),bulk_catmol_pd(6),bulk_catmol_pd(5));
    Mgno_mol_pd(1)=fun_Mg_no_mol(KD_pd(1,7),bulk_catmol_pd(6),bulk_catmol_pd(5));
    c_oxwt_pd(1,:)=pd_maj_comp(P(1),Mgno_pd(1));
    c_oxmol_pd(1,:)=fun_oxmol(c_oxwt_pd(1,:));
    c_catmol_pd(1,:)=fun_catmol(c_oxwt_pd(1,:));
    c_catwt_pd(1,:)=fun_catwt(c_oxwt_pd(1,:));
    res_catmol_pd(1,:)=pd_res_catmol(dF_pd(1),bulk_catmol_pd(6),bulk_catmol_pd(5),c_catmol_pd(1,:));
    
    KD_pd(i+1,:)=fun_KD(X_pd(i+1,:));
    Mgno_pd(i+1)=fun_Mg_no(KD_pd(i+1,7),res_catmol_pd(i,1),res_catmol_pd(i,2));
    Mgno_mol_pd(i+1)=fun_Mg_no_mol(KD_pd(i+1,7),res_catmol_pd(i,1),res_catmol_pd(i,2));
    c_oxwt_pd(i+1,:)=pd_maj_comp(P(i+1),Mgno_pd(i+1));
    c_oxmol_pd(i+1,:)=fun_oxmol(c_oxwt_pd(i+1,:));
    c_catmol_pd(i+1,:)=fun_catmol(c_oxwt_pd(i+1,:));
    c_catwt_pd(i+1,:)=fun_catwt(c_oxwt_pd(i+1,:));
    res_catmol_pd(i+1,:)=pd_res_catmol(dF_pd(i+1),res_catmol_pd(i,1),res_catmol_pd(i,2),c_catmol_pd(i+1,:));
     
    for s=1:7
        %Next calculate point average melt composition by numerical
        %integration
        c_dF_pd(i+1,s)=c_oxwt_pd(i+1,s).*dF_pd(i+1);
        sumc_dF_pd(s)=sum(c_dF_pd(:,s));
        Cun_oxwt_pd(i+1,s)=sumc_dF_pd(s)./F_pd(i+1);
    end
    
    for s=1:7
        if dF_pd(i+1)>0
            C_oxwt_pd(i+1,s)=100*(Cun_oxwt_pd(i+1,s)./sum(Cun_oxwt_pd(i+1,:)));
        end
    end
    
    C_oxmol_pd(1,:)=fun_oxmol(C_oxwt_pd(1,:));
    C_oxmol_pd(i+1,:)=fun_oxmol(C_oxwt_pd(i+1,:));
    C_catmol_pd(1,:)=fun_catmol(C_oxwt_pd(1,:));
    C_catmol_pd(i+1,:)=fun_catmol(C_oxwt_pd(i+1,:));
    C_catwt_pd(1,:)=fun_catwt(C_oxwt_pd(1,:));
    C_catwt_pd(i+1,:)=fun_catwt(C_oxwt_pd(i+1,:));

end

%Calculate point and depth average melt composition for whole melting region

    for i=1:(length(P)-1)
        for s=1:7
            C_F_pd(i+1,s)=C_oxwt_pd(i+1,s).*F_pd(i+1);
        end
    end
    
    for s=1:7
        avCun_oxwt_pd(s)=sum(C_F_pd(:,s))./sum(F_pd);
    end
    for s=1:7
        avC_oxwt_pd(s)=100*(avCun_oxwt_pd(s)./sum(avCun_oxwt_pd(:)));
    end
    avC_oxmol_pd=fun_oxmol(avC_oxwt_pd);



%MINOR AND TRACE ELEMENT COMPOSITION OF MELT
for i=1:(length(P)-1)
    %ol and opx MgO partition coefficients from Beattie et al,1991
    Dol_Mg_pd(1)=fun_Dol_Mg(c_oxmol_pd(1,4),c_oxmol_pd(1,3));
    Dol_Mg_pd(i+1)=fun_Dol_Mg(c_oxmol_pd(i+1,4),c_oxmol_pd(i+1,3));
    Dopx_Mg_pd(1)=fun_Dopx_Mg(c_oxmol_pd(1,4),c_oxmol_pd(1,3));
    Dopx_Mg_pd(i+1)=fun_Dopx_Mg(c_oxmol_pd(i+1,4),c_oxmol_pd(i+1,4));
    
    for j=1:6
        for t=1:8
            %Partition coefficients of minor and trace elements
            D_pd(i+1,:,:)=fun_D(T(i+1),c_oxmol_pd(i+1,:),c_oxwt_pd(i+1,:),KD_pd(i+1,1),Dol_Mg_pd(i+1),Dopx_Mg_pd(i+1));
            
            %set D of 1st interval equal to that of 2nd
            D_pd(1,:,:)=D_pd(2,:,:);
            
            %Calculating bulk D
            X_D_pd(i+1,j,t)=X_pd(i+1,j).*D_pd(i+1,j,t);
            bulkD_pd(i+1,t)=sum(X_D_pd(i+1,:,t));
            bulkD_pd(1,:)=bulkD_pd(2,:);
            
            %Instantaneous melt trace element composition
            ctl_pd(1,t)=fun_ctl(dF_pd(1),cts_pd(1,t),bulkD_pd(1,t),n_pd(1,:),D_pd(1,:,t));
            ctl_pd(i+1,t)=fun_ctl(dF_pd(i+1),cts_pd(i,t),bulkD_pd(i+1,t),n_pd(i+1,:),D_pd(i+1,:,t)); 
            if ctl_pd(i+1,t)<=0   %Positivity constraint
                ctl_pd(i+1,t)=0;
            end
            
            %Solid residue trace element composition
            cts_pd(i+1,t)=(cts_pd(i,t)-ctl_pd(i+1,t).*dF_pd(i+1))./(1-dF_pd(i+1));
            if cts_pd(i+1,t)<=0
                cts_pd(i+1,t)=0;
            end
        end
    end
end

%Point average melt trace element composition
for i=1:(length(P)-1)
    for t=1:8
        ctl_dF_pd(i+1,t)=ctl_pd(i+1,t).*dF_pd(i+1);
    end
end
for i=1:(length(P)-1)
    for t=1:8
        Ctl_pd(1,t)=ctl_pd(1,t);
        Ctl_pd(i+1,t)=sum(ctl_dF_pd(1:i+1,t))./F_pd(i+1);
    end   
end

%Point and depth average melt trace element composition
for i=1:(length(P)-1)
    for t=1:8
        Ctl_F_pd(1,t)=Ctl_pd(1,t).*F_pd(1);
        Ctl_F_pd(i+1,t)=Ctl_pd(i+1,t).*F_pd(i+1);
    end
end
for i=1:length(P)
    for t=1:8
        avCtl_pd(t)=sum(Ctl_F_pd(:,t))./sum(F_pd(:));
    end
end

%SHALLOW CRYSTALLISATION OF PRIMITIVE OLIVINE
for i=1:(length(P)-1)
    %Major element composition of olivines
    Fo_pd(1)=fun_Fo(c_oxmol_pd(1,4),c_oxmol_pd(1,3),KD_pd(1,1));
    Fo_pd(i+1)=fun_Fo(c_oxmol_pd(i+1,4),c_oxmol_pd(i+1,3),KD_pd(i+1,1));
    col_catmol_pd(i+1,:)=fun_col_catmol(Fo_pd(i+1));
    col_catwt_pd(i+1,:)=fun_col_catwt(Fo_pd(i+1));
    col_oxmol_pd(i+1,:)=col_catmol_pd(i+1,:);
    col_oxwt_pd(i+1,:)=fun_col_oxwt(Fo_pd(i+1));
    
    Fo_ptav_pd(1)=fun_Fo(C_oxmol_pd(1,4),C_oxmol_pd(1,3),KD_pd(1,1));
    Fo_ptav_pd(i+1)=fun_Fo(C_oxmol_pd(i+1,4),C_oxmol_pd(i+1,3),KD_pd(i+1,1));
    Col_catmol_pd(i+1,:)=fun_col_catmol(Fo_ptav_pd(i+1));
    Col_catwt_pd(i+1,:)=fun_col_catwt(Fo_ptav_pd(i+1));
    Col_oxmol_pd(i+1,:)=Col_catmol_pd(i+1,:);
    Col_oxwt_pd(i+1,:)=fun_col_oxwt(Fo_ptav_pd(i+1));

    avFo_pd=fun_Fo(avC_oxmol_pd(4),avC_oxmol_pd(3),KD_pd(1,1));
    
    %Temperature of shallow basalt liquidus at 6km (0.2GPa) in crust
    %1)for instantaneous melts
    Tbasliq_pd(1)=fun_Tbasliq(0.2,c_oxwt_pd(1,:),Mgno_mol_pd(1));
    Tbasliq_pd(i+1)=fun_Tbasliq(0.2,c_oxwt_pd(i+1,:),Mgno_mol_pd(i+1));
    %2)for point average melts
    Tbasliq_ptav_pd(i+1)=fun_Tbasliq(0.2,C_oxwt_pd(i+1,:),Fo_ptav_pd(i+1)/100);
    %3)for point and depth average melts
    avTbasliq_pd=fun_Tbasliq(0.2,avC_oxwt_pd(:),avFo_pd/100);
    
    %ol-L partition coefficients at basalt liquidus T
    %1)for instantaneous melts
    D_shallow_pd(i+1,:)=fun_Dol(Tbasliq_pd(i+1),c_oxmol_pd(i+1,:),c_oxwt_pd(i+1,:),KD_pd(i+1,1),Dol_Mg_pd(i+1));
    %2)for point average melts
    Dol_Mg_ptav_pd(1)=fun_Dol_Mg(C_oxmol_pd(1,4),C_oxmol_pd(1,3));
    Dol_Mg_ptav_pd(i+1)=fun_Dol_Mg(C_oxmol_pd(i+1,4),C_oxmol_pd(i+1,4));
    D_ptav_pd(i+1,:)=fun_Dol(Tbasliq_ptav_pd(i+1),C_oxmol_pd(i+1,:),C_oxwt_pd(i+1,:),KD_pd(i+1,1),Dol_Mg_ptav_pd(i+1));
    D_ptav_pd(1,:)=D_ptav_pd(2,:);
    %3)for point and depth average melts
    avDol_Mg_pd=fun_Dol_Mg(avC_oxmol_pd(4),avC_oxmol_pd(3));
    avD_pd=fun_Dol(avTbasliq_pd,avC_oxmol_pd,avC_oxwt_pd,KD_pd(1,1),avDol_Mg_pd);
    
    %Minor element concentration of primitive olivine
    for j=1:6
        for t=1:8
            %1)incremental fractional melts
            ctol_pd(1,t)=ctl_pd(1,t).*D_shallow_pd(1,t);
            ctol_pd(i+1,t)=ctl_pd(i+1,t).*D_shallow_pd(i+1,t);
            %2)pt average melts
            Ctol_pd(1,t)=Ctl_pd(1,t).*D_ptav_pd(1,t);
            Ctol_pd(i+1,t)=Ctl_pd(i+1,t).*D_ptav_pd(i+1,t);
            %3)pt and depth average melts
            avCtol_pd(t)=avCtl_pd(t).*avD_pd(t);
        end
    end
end

%%
figure

Tsol_px=px_Tsol(P);
Tcpx_px=px_Tcpx(P);
Tsol_pd=pd_Tsol(P);
Tcpx_pd=pd_Tcpx(P);
Tliq_pd=pd_Tliq(P);

subplot(2,2,1);
plot(P,T,P,Tsol_px,P,Tcpx_px,P,Tsol_pd,P,Tcpx_pd,P,Tliq_pd);
xlabel('P/GPa');
ylabel('T/degC');
legend('T','Tsolpx','Tcpxpx','Tsolpd','Tcpxpd','Tliqpd');

subplot(2,2,2);
plot(P,F,P,F_px,P,F_pd);
xlabel('P/GPa');
ylabel('F/wtfraction');
legend('F_a_g_g','F_p_x','F_p_d');

subplot(2,2,3);
plot(X_pd,P);
title('mineralogy (pd)');
xlabel('X');
ylabel('P');
legend('ol','opx','cpx','plag','sp','gt');

subplot(2,2,4);
plot(c_oxwt_pd,P);
title('instantaneous melt composition (pd)');
xlabel('wt fraction');
ylabel('P/GPa');
legend('sio2','al2o3','feo','mgo','cao','nao','fe2o3');

figure

subplot(2,2,1);
plot(bulkD_pd,P);
title('bulk partition coefficent');
xlabel('bulkD_m_i_n_-_L');
ylabel('P/GPa');
legend('Ni','Mn','V','Cr','Ti','Co','Sc','Zn')

subplot(2,2,2);
plot(Fo_pd,P,Fo_ptav_pd,P);
title('Fo');
xlabel('Fo');
ylabel('P/GPa');
legend('instantaneous','ptav');

subplot(2,2,3);
plot(P,ctl_pd(:,1),P,ctl_pd(:,2));
title('instantaneous melt comp');
xlabel('Fo');
ylabel('c_i_-_o_l');
legend('Ni','Mn')

subplot(2,2,4);
plot(Fo_pd,ctol_pd(:,1),Fo_pd,ctol_pd(:,2));
title('primitive olivines comp');
xlabel('Fo');
ylabel('c_i_-_o_l');
legend('Ni','Mn')

end











