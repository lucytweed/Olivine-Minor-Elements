function Mcpx=cpx_fitting(P,Tcpx)

global r0 r1

Tsol=pd_Tsol(P);
Tliq=pd_Tlherzliq(P);

Mcpx=(r0+r1*P)*((Tcpx-Tsol)/(Tliq-Tsol))^(3/2);

end