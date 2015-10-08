function dTdP_S=fun_dTdPpxcpx(P,T,phi)

%px-only melting with residual cpx

F=px_F1(P,T);
dTdF_P=px_dT1dF(P,F);
dTdP_F=px_dT1dP(P,F);

dFdP_S=1e-9*px_dFdP1cpx(P,F,phi);

dTdP_S=1e9*(dTdP_F+dTdF_P*dFdP_S);

end

