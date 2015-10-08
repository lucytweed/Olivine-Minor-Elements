function c_oxwt=pd_maj_comp(P,Mg_no,X,n,Na2O_res,dF)

% [SiO2, Al2O3, FeO, MgO, CaO, Na2O, Fe2O3]
% [ 1  ,  2  ,  3  ,  4  , 5 ,   6 ,   7  ]

Pgt_out=pd_Pgt_out();
Psp_out=pd_Psp_out();

if P>Pgt_out
    %CaO
    C=-3.971.*log(P)+17.255;
    %MgO
    M=10.964.*log(P)+12.293;
    %Al2O3
    A=-9.985.*log(P)+26.220;
    %SiO2
    S=0.545.*P+46.042;
else if P>Psp_out
        %CaO
        C=-0.877.*P+15.899;
        %MgO
        M=4.438.*P+10.267;
        %Al2O3
        A=-1.877.*P+22.099;
        %SiO2
        S=-1.171.*P+50.593;
    else %CaO
        C=-0.540.*P+15.540;
        %MgO
        M=2.600.*P+12.000;
        %Al2O3
        A=3.390.*P+16.810;
        %SiO2
        S=-6.240.*P+55.640;
    end
end

%Na2O calculated by treating Na as a trace element 
%Partition coefficients
Dol=0.001;
if P>1
    Dopx=0.057*P-0.035;
    Dcpx=0.114*P+0.043;
else Dopx=0.022;
    Dcpx=0.157;
end
Dplag=1;
Dsp=0.001;
Dgt=0.04;
D=[Dol,Dopx,Dcpx,Dplag,Dsp,Dgt];
%bulk partition coefficient
bulkD=sum(X.*D);
%Modified partition coefficient
Q=sum(n.*D);
%Na2O conc in melt calculated using fractional melting equ 
Na2O_un=(Na2O_res/bulkD)*(1-(Q*dF/bulkD))^((1/Q)-1);

%M in CMAS projection split into MgO and FeO components
MgO_un=M.*Mg_no;
FeO_un=M.*(1-Mg_no);

%Ferric Fe calculated assuming Fe2+/FeT=0.9
Fe2O3_un=0.1*FeO_un;

%CaO, Al2O3 & SiO2 calculated using CMAS projection
CaO_un=C-2*Na2O_un;
Al2O3_un=A-Fe2O3_un;
SiO2_un=S+2*Na2O_un;

%Normalising to 100%
c_oxwt_un=[SiO2_un,Al2O3_un,FeO_un,MgO_un,CaO_un,Na2O_un,Fe2O3_un];
c_oxwt=100*(c_oxwt_un./sum(c_oxwt_un));

end