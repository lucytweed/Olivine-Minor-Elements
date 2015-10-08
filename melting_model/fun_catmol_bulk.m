function c_catmol=fun_catmol_bulk(c_oxwt)

% Molar masses of oxides 
ox_molar_mass=[60.1,79.9,152,102,71.8,40.3,56.1,70.9,74.7,62,94.2];

% Number of cations per formula unit
cation_no=[1,1,2,2,1,1,1,1,1,2,2];

% Unnormalized oxide proportions
c_catmol_un=(c_oxwt./ox_molar_mass).*cation_no;

% Normalized oxide mol%
c_catmol=(c_catmol_un/sum(c_catmol_un(:)))*100;

end

