function dFdP_S=pd_dFdP1cpx(P,F)

%pd only melting with residual cpx

global Cp_pd alpha_pd rho_pd

dTdP_F=pd_dT1dP(P,F);
dTdF_P=pd_dT1dF(P,F);

dFdP_S=-1e9*((dTdP_F*Cp_pd/T-alpha_pd/rho_pd)/(delS_pd+dTdF_P*Cp_pd/T));

end