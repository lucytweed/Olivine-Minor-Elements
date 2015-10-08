function c_catwt=fun_catwt(bulk_c_oxwt)

% Molar masses of oxides 
ox_molar_mass=[60.1,102,71.8,40.3,56.1,62,159.7];

% Molar masses of cations
cat_molar_mass=[28.1,27.0,55.8,24.3,40.1,23.0,55.8];

% Number of cations per formula unit
cation_no=[1,2,1,1,1,2,2];

% Unnormalized oxide proportions
c_catwt_un=(bulk_c_oxwt.*cation_no.*cat_molar_mass)./ox_molar_mass;

% Normalized oxide mol%
c_catwt=(c_catwt_un/sum(c_catwt_un(:)))*100;

end


