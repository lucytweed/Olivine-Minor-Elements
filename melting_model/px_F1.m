function F1=px_F1(P,T)

%Melt fraction before cpx exhaustion

Tsol=px_Tsol(P);
Tcpx=px_Tcpx(P);

F1=0.4154*(T-Tsol)/(Tcpx-Tsol)+0.3187864*((T-Tsol)/(Tcpx-Tsol))^2;

if F1<=0
    F1=0;
end
if F1>=1
    F1=1;
end

end