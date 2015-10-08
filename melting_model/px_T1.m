function T1=px_T1(P,F)

%T as a function of melt fraction after cpx exhaustion

Tcpx=px_Tcpx(P);
Tsol=px_Tsol(P);

T1= (740963735892385631*Tsol)/448651972578369375 - (292311763314016256*Tcpx)/448651972578369375 + (1125899906842624*Tcpx*((717843156125391*F)/562949953421312 + 4313929/25000000)^(1/2))/717843156125391 - (1125899906842624*Tsol*((717843156125391*F)/562949953421312 + 4313929/25000000)^(1/2))/717843156125391;

end