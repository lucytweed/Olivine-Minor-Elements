function dFdP_S=px_dFdP2(P,F,phi)

%px & pd only melting cpx is exhausted in px and pd

global Cp_px Cp_pd alpha_px alpha_pd rho_px rho_pd delS_px delS_pd

T=px_T2(P,F);
dTdF_px=px_dT2dF(P,F);
dTdP_px=px_dT2dP(P,F);
dTdF_pd=pd_dT2dF(P,F);
dTdP_pd=pd_dT2dP(P,F);

Cp=phi*Cp_px+(1-phi)*Cp_pd;
alpha=phi*alpha_px+(1-phi)*alpha_pd;
rho=phi*rho_px+(1-phi)*rho_pd;

dFdP_S=-1e9*(((Cp/T)*dTdP_px-alpha/rho+(1-phi)*delS_pd*(dTdP_px-dTdP_pd)/dTdF_pd)...
    /(phi*delS_px+(1-phi)*delS_pd*dTdF_px/dTdF_pd+dTdF_px*Cp/T));

end