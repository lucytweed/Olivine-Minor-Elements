function F=pd_F2(P,T)
%Melt fraction when T<Tcpx

% global Mcpx r0 r1

Tliq=pd_Tliq(P);
Tcpx=pd_Tcpx(P);
Fcpxpd_Fcpx(P);

F=Fcpx+(1-Fcpx)*((T-Tcpx)/(Tliq-Tcpx))^1.5;

end
