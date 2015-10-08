function dFdP_S=pd_dFdP2(P,F,phi)

%px & pd melting when cpx is exhausted in both lithologies

dTdF_px=px_dT2dF(P,F);
dTdP_px=px_dT2dP(P,F);
dTdF_pd=pd_dT2dF(P,F);
dTdP_pd=pd_dT2dP(P,F);

dFdP_Spx=1e-9*px_dFdP2(P,F,phi);

dFdP_S=1e9*(dFdP_Spx*dTdF_px/dTdF_pd+(dTdP_px-dTdP_pd)/dTdF_pd);

end