function dTdP_S=fun_dTdPpd(P,T)

%pd only melting when cpx is exhausted

F=pd_F2(P,T);
dTdP_F=pd_dT2dP(P,F);
dTdF_P=pd_dT2dF(P,F);
dFdP_S=1e-9*pd_dFdP1(P,F);

dTdP_S=1e9*(dTdP_F-dTdF_P*dFdP_S);

end