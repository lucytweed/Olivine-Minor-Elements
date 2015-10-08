function [Tsol_px,Tcpx_px,Tliq_px,Tsol_pd,Tcpx_pd,Tliq_pd]=fun_plot

P=10:-0.1:0;
Tsol_px=zeros(length(P),1);
Tcpx_px=zeros(length(P),1);
Tliq_px=zeros(length(P),1);
Tsol_pd=zeros(length(P),1);
Tcpx_pd=zeros(length(P),1);
Tliq_pd=zeros(length(P),1);

for i=1:length(P)
    Tsol_px(i)=px_Tsol(P(i));
    Tcpx_px(i)=px_Tcpx(P(i));
    Tliq_px(i)=px_Tliq(P(i));
    Tsol_pd(i)=pd_Tsol(P(i));
    Tcpx_pd(i)=pd_Tcpx(P(i));
    Tliq_pd(i)=pd_Tliq(P(i));
    
end

figure

plot(P,Tsol_px,P,Tcpx_px,P,Tliq_px,P,Tsol_pd,P,Tcpx_pd,P,Tliq_pd);
legend('px_Tsol','px_Tcpx','px_Tliq','pd_Tsol','pd_Tcpx','pd_Tliq');   

end