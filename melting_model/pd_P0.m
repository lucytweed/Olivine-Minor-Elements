function P0 = pd_P0()

P1 = 5;  % Make a starting guess at the solution
P0 = fsolve(@pd_intersection,P1); % Call solver

end





