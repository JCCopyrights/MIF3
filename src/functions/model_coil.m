function [R,L,C]=model_coil(L,Rs,fres,f)
	w=2*pi*f;
	wres=2*pi*fres;
	C=1/(wres^2*L);
	syms Ry;
	eqn=Rs==Ry/(w^2*Ry^2*C^2+(1-L*C*w^2)^2);
	var= [Ry];
	solx=solve(eqn,var);
	R=min(double(solx)); %Never trust this function

	