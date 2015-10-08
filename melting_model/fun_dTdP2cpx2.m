function dTdP_S=fun_dTdP2cpx2(P,T,phi)

%px & pd melting with residual cpx in px and pd

F=px_F1(P,T);
dTdF_P=px_dT1dF(P,F);
dTdP_F=px_dT1dP(P,F);

dFdP_S=1e-9*px_dFdP2cpx2(P,F,phi);

dTdP_S=1e9*(dTdP_F+dTdF_P*dFdP_S);

end