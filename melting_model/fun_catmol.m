function c_catmol=fun_catmol(c_oxwt)

% Molar masses of oxides 
ox_molar_mass=[60.1,102,71.8,40.3,56.1,62,159.7];

% Number of cations per formula unit
cation_no=[1,2,1,1,1,2,2];

% Unnormalized oxide proportions
c_catmol_un=(c_oxwt./ox_molar_mass).*cation_no;

% Normalized oxide mol%
c_catmol=(c_catmol_un/sum(c_catmol_un(:)))*100;

end

