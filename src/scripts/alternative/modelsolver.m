	filename='test.csv';
	data=import_bode100(filename);
	model=model_bode100(data,100e3);
    
	%% Real Coil Model
	% The parasitic effects of Cp and L over the Real impedance cannot be ignored
	% The parasitic effect of Rp near resonance cannot be ignored, but adding Rp to the impedance eliminates
	% any simple mathematical solution. So try not to work near resonance maybe?
	% @TODO: Introduce a numerical method to approximate model values withoud analytical constrains
	failures=0;
	wait=waitbar(0,'Initialization');
	for i=1:1:length(model.f)
		text = sprintf('Run freq=%i', model.f(i));
		waitbar(i/length(model.f),wait,text);
		syms R Rp
		w=2*pi*model.f(i);
		Cp=model.Cp(i);
		L=model.L(i);
		ZC=1/(j*w*Cp);
		ZLR=R+j*w*L;
		ZP=Rp;
		Znd=ZC*ZLR/(ZC+ZLR);
		Z=Znd*ZP/(Znd+ZP);
		eq1=real(Z)-data.raw.Rs(i)==0;
		eq2=imag(Z)-data.raw.Ls(i)*w==0;
		sol=vpasolve([eq1,eq2],[Rp,R],[0,model.Rp(i); model.R(i)/2,model.R(i)]); %
		if isempty(sol.R) %Failed at solving
			model.R(i)=model.R(i); 
			model.Rp(i)=model.Rp(i);	
			failures=[failures model.f(i)];
		else
			model.R(i)=double(sol.R);
			model.Rp(i)=double(sol.Rp);
		end;
	end;

	