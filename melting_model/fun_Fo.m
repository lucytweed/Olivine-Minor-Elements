function Fo=fun_Fo(MgO_molar,FeO_molar,KD)

r=MgO_molar/(KD*FeO_molar);

Fo=100*r/(r+1);

if Fo>100
    Fo=0;
end

end
