function dFdP_S=px_dFdP1cpx(P,F,phi)

%px-only melting with residual cpx

global Cp_px Cp_pd alpha_px alpha_pd rho_px rho_pd delS_px

T=px_T1(P,F);
dTdF=px_dT1dF(P,F);
dTdP=px_dT1dP(P,F);

Cp=phi*Cp_px+(1-phi)*Cp_pd;
alpha=phi*alpha_px+(1-phi)*alpha_pd;
rho=phi*rho_px+(1-phi)*rho_pd;

dFdP_S=-1e9*(((Cp/T)*dTdP-alpha/rho)/(phi*delS_px+(Cp/T)*dTdF));

end