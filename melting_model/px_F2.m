function F2=px_F2(P,T)

global Mcpx r0 r1

%melt fraction after cpx exhaustion

Tcpx=px_Tcpx(P);
Tliq=px_Tliq(P);

F2=Mcpx/(r0+r1*P)+(1-Mcpx/(r0+r1*P))*((T-Tcpx)/(Tliq-Tcpx))^1.5;

end