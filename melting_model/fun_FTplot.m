function [F,T]=fun_FTplot()
global Mcpx

Mcpx=0.08;

P=0:1:6;
F=0:0.001:1;
T=zeros(length(P),length(F));

for j=1:length(P)
    for i=1:length(F)-1
        T(j,1)=pd_T1(P(j),F(1));
        if T(j,i)<pd_Tcpx(P(j))
            T(j,i+1)=pd_T1(P(j),F(i+1));
        else T(j,i+1)=pd_T2(P(j),F(i+1));
        end
    end
end

figure
plot(T(1,:),F,T(2,:),F,T(3,:),F,T(4,:),F,T(5,:),F,T(6,:),F,T(7,:),F);
xlabel('T/degC');
ylabel('F/wt fraction');
legend('0GPa','1GPa','2GPa','3GPa','4GPa','5GPa','6GPa')

end