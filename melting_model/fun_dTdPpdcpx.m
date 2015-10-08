function dTdP_S=fun_dTdPpdcpx(P,T)

%pd only melting with residual cpx

F=pd_F1(P,T);
dTdP_F=pd_dT1dP(P,F);
dTdF_P=pd_dT1dF(P,F);
dFdP_S=1e-9*pd_dFdP1cpx(P,F);

dTdP_S=1e9*(dTdP_F-dTdF_P*dFdP_S);

end