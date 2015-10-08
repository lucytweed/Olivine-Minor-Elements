function T=fun_adiabat(P,phi)

global Tp alpha_pd alpha_px rho_pd rho_px Cp_pd Cp_px

alpha=phi*alpha_px+(1-phi)*alpha_pd;
rho=phi*rho_px+(1-phi)*rho_pd;
Cp=phi*Cp_px+(1-phi)*Cp_pd;


T = Tp*exp((alpha*P*1e9)/(rho*Cp));

end
