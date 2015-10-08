function dFdP_S=pd_dFdP1(P,F)

%pd only melting when cpx is exhausted

global Cp_pd alpha_pd rho_pd

dTdP_F=pd_dT2dP(P,F);
dTdF_P=pd_dT2dF(P,F);

dFdP_S=-1e9*((dTdP_F*Cp_pd/T-alpha_pd/rho_pd)/(delS_pd+dTdF_P*Cp_pd/T));

end