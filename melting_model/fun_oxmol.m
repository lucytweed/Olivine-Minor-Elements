function c_oxmol=fun_oxmol(c_oxwt)

% Molar masses of oxides 
ox_molar_mass=[60.1,102,71.8,40.3,56.1,62,159.7];

% Unnormalized oxide proportions
c_oxmol_un=c_oxwt./ox_molar_mass;

% Normalized oxide mol%
c_oxmol=(c_oxmol_un/sum(c_oxmol_un(:)))*100;

end

