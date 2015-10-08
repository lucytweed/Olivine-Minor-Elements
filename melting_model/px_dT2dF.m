function dT2dF=px_dT2dF(P,F)

global Mcpx r0 r1

% dT2dF=-(2*((91*P^2)/10-(561*P)/5+3002/5))/(3*(3/(20*((2*P)/25+1/2))-1)*(-...
%     (F-3/((8*P)/5+10))/(3/((8*P)/5+10)-1))^(1/3));

dT2dF=-(2*((91*P^2)/10 - (561*P)/5 + 3002/5))/(3*(Mcpx/(r0 + P*r1) - 1)*(-...
   (F - Mcpx/(r0 + P*r1))/(Mcpx/(r0 + P*r1) - 1))^(1/3));

end
