function dTdP_S=fun_dTdP2(P,T,phi)

%px & pd melting when cpx is exhausted in px and pd

F=px_F2(P,T);
dTdF_P=px_dT2dF(P,F);
dTdP_F=px_dT2dP(P,F);
dFdP_S=1e-9*px_dFdP2(P,F,phi);

dTdP_S=1e9*(dTdP_F+dTdF_P*dFdP_S);

end