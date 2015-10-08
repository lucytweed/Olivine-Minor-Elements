function F=pd_F1(P,T)

%Melt fraction when T>Tcpx

Tsol=pd_Tsol(P);
Tlherzliq=pd_Tlherzliq(P);

F = ((T-Tsol)/(Tlherzliq-Tsol))^1.5;

end
