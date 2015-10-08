%%
function ctl=fun_ctl(dF,cts,bulkD,n,D)

nmin=n(1:6);

P=sum(nmin.*D);

ctl=(cts./bulkD).*(1-((dF.*P)./bulkD))^((1./P)-1);

end
%%