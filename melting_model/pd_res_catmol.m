function res_catmol=pd_res_catmol(dF,MgO_bulk_catmol,FeO_bulk_catmol,melt_c_catmol)

res_catmol=zeros(2,1);

res_catmol(1)=(1/(1-dF))*(MgO_bulk_catmol-dF*melt_c_catmol(4));

res_catmol(2)=(1/(1-dF))*(FeO_bulk_catmol-dF*melt_c_catmol(3));

end