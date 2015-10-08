function Y = pd_intersection( P0 )

global Tp

Y=Tp.*exp(-(3*10^-5*10^9*10^-4)./(3200*1200)).*exp((3*10^-5*10.^9.*P0)./...
    (3200.*1200))-1085.7-132.9*P0+5.1*P0.^2;
end

