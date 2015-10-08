function dT1dP=pd_dT1dP(P,F)

dT1dP=1e-9*(F^(2/3)*(3.8*P-52.9)-10.2*P+132.9);

end