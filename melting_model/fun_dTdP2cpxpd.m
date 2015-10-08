function dTdP_S=fun_dTdP2cpxpd(P,T,phi)

%px & pd melting with residual cpx in pd only

F=px_F2(P,T);
dTdF_P=real(px_dT2dF(P,F));
dTdP_F=real(px_dT2dP(P,F));
dFdP_S=real(1e-9*px_dFdP2cpxpd(P,F,phi));

dTdP_S=1e9*(dTdP_F+dTdF_P*dFdP_S);

end