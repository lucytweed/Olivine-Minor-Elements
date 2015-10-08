function dFdP_S=px_dFdP1(P,F,phi)

%px-only melting when cpx is exhausted

global Cp_px Cp_pd alpha_px alpha_pd rho_px rho_pd delS_px

T=px_T2(P,F);
dTdF=px_dT2dF(P,F);
dTdP=px_dT2dP(P,F);

Cp=phi*Cp_px+(1-phi)*Cp_pd;
alpha=phi*alpha_px+(1-phi)*alpha_pd;
rho=phi*rho_px+(1-phi)*rho_pd;

dFdP_S=-1e9*(((Cp/T)*dTdP-alpha/rho)/(phi*delS_px+(Cp/T)*dTdF));

end