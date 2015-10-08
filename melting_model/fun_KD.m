function KD=fun_KD(X)

KD=zeros(1,7);

%Olivine: from Herzberg & O'Hara, 2002
KD(1)=0.34;

%Orthopyroxene: as in Kinzler 1997
KD(2)=0.91*KD(1);

%Clinopyroxene: as in Kinzler 1997
KD(3)=0.94*KD(1);

%Plagioclase: From Sugawara, 2000
KD(4)=1.0;

%Spinel: as in Kinzler 1997
KD(5)=1.5*KD(1);

%Garnet: From Walter,1998
KD(6)=0.45;

%Bulk KD of assemblage
X_KD=X.*KD(1:6);
KD(7)=sum(X_KD);

end
