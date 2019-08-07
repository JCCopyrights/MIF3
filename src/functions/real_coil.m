%% Real Coil
% [Rs, Ls, fres]=real_coil(L,R,C,f)
%
% Author: JCCopyrights Summer 2019
% This function takes the inductance, resistivity and resistance of a real coil model(C//RL)
% and returns the Series resistance and inductance of the series model (RL), and the resonance frecuency.
% Use this function to take into acount the resonance effects over the impedance after creating a model with FastHenry
%
%% Parameters
% * @param 	*L*		Inductance
%
% * @param 	*R*		Winding resistivity (Copper Losses)
%
% * @param 	*C*		Parasitic capacitance
%
% * @param 	*f*		Working frecuency
%
% * @retval	*Rs* 	Series Real Impedance
%
% * @retval	*Ls* 	Series Inductance
%
% * @retval	*fres* 	LC resonance frecuency
%% Code	

function [Rs, Ls, fres]=real_coil(L,R,C,f)
	w=2*pi*f;
	Zre=R./(w.^2.*R.^2*C^2+(1-L*C*w.^2).^2);
	Zim=(w.*L.*(1-w.^2.*L.*C-(C.*R.^2)./L))./(w.^2.*R.^2.*C^2+(1-L.*C.*w.^2).^2);
	Z=sqrt(Zre.^2+Zim.^2);
	Rs=Zre;
	Ls=Zim/w;
	fres=1/(2*pi*sqrt(L*C));