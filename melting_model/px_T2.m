function T2=px_T2(P,F)

global Mcpx r0 r1

%T as a function of P and F after cpx exhaustion

Tcpx=px_Tcpx(P);
Tliq=px_Tliq(P);

T2=(Tliq-Tcpx)*((F-Mcpx/(r0+r1*P))/(1-Mcpx/(r0+r1*P)))^(2/3)+Tcpx;

end
