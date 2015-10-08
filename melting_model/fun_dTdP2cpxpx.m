function dTdP_S=fun_dTdP2cpxpx(P,T,phi)

%px & pd melting with residual cpx in px only

F=px_F1(P,T);
dTdF_P=px_dT1dF(P,F);
dTdP_F=px_dT1dP(P,F);
dFdP_S=1e-9*px_dFdP2cpx(P,F,phi);

dTdP_S=1e9*(dTdP_F+dTdF_P*dFdP_S);

end