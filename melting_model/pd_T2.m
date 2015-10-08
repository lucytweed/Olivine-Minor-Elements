function T2=pd_T2(P,F)
%T as a function of P and F after cpx exhaustion

% global Mcpx r0 r1

Tcpx=pd_Tcpx(P);
Tliq=pd_Tliq(P);
Fcpx=pd_Fcpx(P);

T2=(Tliq-Tcpx)*((F-Fcpx)/(1-Fcpx))^(2/3)+Tcpx;

end