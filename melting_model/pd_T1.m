function T1=pd_T1(P,F)

%T as a function of F and P before cpx exhaustion

Tlherzliq=pd_Tlherzliq(P);
Tsol=pd_Tsol(P);

T1=F^(2/3)*(Tlherzliq-Tsol)+Tsol;

end