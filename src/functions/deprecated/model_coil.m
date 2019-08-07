%% Real Coil
% [R,L,C]=model_coil(L,Rs,fres,f)
%
% Author: JCCopyrights Summer 2019
% This function takes the inductance (DC), series resistivity(AC at frecuency f) 
% resonance frecuency and working frecuency
% And returns the R, L and C of the inductance real model (C//LR)
% Use this function to generate the real model of the coil with impedance measurements.
% DO NOT TRUST THIS TOO MUCH @TODO:FIX
%
%% Parameters
% * @param  *L*	Inductance
%
% * @param 	*Rs*    Series real resistance
%
% * @param	*fres* 	LC resonance frecuency
%
% * @param 	*f*		Working frecuency
%
% * @retval	*R* 	Winding Resistance
%
% * @retval	*Ls* 	Series Inductance
%
% * @retval 	*C*		Parasitic capacitance

%% Code	



function [R,L,C]=model_coil(L,Rs,fres,f)
	w=2*pi*f;
	wres=2*pi*fres;
	C=1/(wres^2*L);
	syms Ry;
	eqn=Rs==Ry/(w^2*Ry^2*C^2+(1-L*C*w^2)^2);
	var= [Ry];
	solx=solve(eqn,var);
	R=min(double(solx)); %Never trust this function

	