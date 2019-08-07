function model=solve_model(data,f)
	[ trash, i_aprox ] = min(abs( data.raw.f-f));
	model.f_aprox=data.raw.f(i_aprox);
	[Rp_aprox, i_res]=max(data.raw.Rs); 
	f_res=data.raw.f(i_res);
	freq_L=100e3;
	[ trash, i_L ] = min(abs( data.raw.f-freq_L));
	L_res=data.raw.Ls(i_L); 	
	Cpp=(1./((2*pi*f_res)^2.*L_res));
	
	
	w=2*pi*model.f_aprox;
	
	syms R Rp L Cp
	ZC=1/(j*w*Cp);
	ZLR=R+j*w*L;
	ZP=Rp;
	Znd=ZC*ZLR/(ZC+ZLR);
	Z=Znd*ZP/(Znd+ZP);
	eq1=real(Z)==data.raw.Rs(i_aprox);
	eq2=imag(Z)==data.raw.Ls(i_aprox)*w;
	eq3=f_res==1/(2*pi*sqrt(L*Cp));
	sol=vpasolve([eq1,eq2,eq3],[Rp,R,L,Cp], [Rp_aprox,data.raw.Rs(i_aprox),L_res,Cpp]); %
	if isempty(sol.R) %Failed at solving
		model.R=data.raw.Rs(i_aprox); 
		model.Rp=Rp_aprox;	
		error('No solvable');
	else
		model.R=double(sol.R);
		model.Rp=double(sol.Rp);
		model.L=double(sol.L);
		model.Cp=double(sol.Cp);
	end; 
	

