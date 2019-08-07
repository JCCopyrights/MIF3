%% Optimize Discretization
% [nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta)
%
% Author: JCCopyrights Summer 2019
% Optimizes the discretization of the conductors leaving delta as the smallest filament
% Returns the discretization values nhinc and nwinc
% rh,rw is the relation of height and width of following filaments
%% Parameters
% * @param 	*w*		Width of conductor
%
% * @param 	*h*		Height of conductor
%
% * @param 	*rh*	Height relation of Following Filaments
%
% * @param 	*rw*	Weight relation of Following Filaments
%
% * @param 	*delta*	Skin effect
%
% * @retval	*nhinc* Number of Height Filaments	
%
% * @retval	*nwinc* Numer of Weight Filaments	
%% Code	
function [nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta)
	nhinc=optimize_size(h,rh,delta);
	nwinc=optimize_size(w,rw,delta);
	
%mu0=4*pi*1e-7; 
%freq=500e3;
%skin=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0));

%%Auxiliar Function
function [nwinc]=optimize_size(w,rw,delta)
	sum=0;
	if delta<w %No need to discretizate the cable
		for nwinc=2:2:100 %Maximum allowed discretization 100x100
			sum=sum+2*rw^((nwinc-2)/2)*delta; %nwinc even
			if sum>=w
				break;
			end
			aux=sum+rw^(nwinc/2)*delta; %nwinc odd
			if aux>=w
				nwinc=nwinc+1;
				break;
			end
		end
	else
		nwinc=1;
	end
%% Discretization 	
% 
% <<..\..\doc\functions\res\discretizacion.PNG>>
% 
% <<..\..\doc\functions\res\discr_opt.PNG>>
% 

