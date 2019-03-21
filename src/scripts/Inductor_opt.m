%% Optimizaton Process for Round Inductors.
% Iterates different turns and distances for the coils

addpath('../functions')
N1=10; 
d1=0.5e-3;
D1=30e-3;
RES=400;

%Create the coil structs compatible with FastHenry2
freq=500e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=10; rw=10; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect

figure();
range=20;
f=waitbar(0,'Initialization');

	for N1=1:1:range
		i=1;
		for d1=w:w/5:D1/(2*N1)
			text = sprintf('N1: %i : d1: %g', N1,d1);
			waitbar(N1/range,f,text);
			clf('reset') 
			hold on;
			X = round_spiral(N1, D1/2, d1, 0, RES, 0, 0, 0, 0, 0, 0,true);
			[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w,h,nhinc,nwinc,rh,rw);
			coils={primary};
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
			Rs=squeeze((R(1,:,:)));
			Ls=squeeze((L(1,:,:)));
			R1(N1,i)=Rs(1,1);
			L1(N1,i)=Ls(1,1);
			Q1(N1,i)=2*pi*freq*Ls(1,1)/Rs(1,1);
			%%%%%%%%%%%%
			dout=D1+w/2;
			s=d1-w;
			din=dout-(2*N1)*w-2*(N1-1)*s;
			davg=0.5*(dout+din);
			rho(N1,i)=(dout-din)/(dout+din);
			%%%%%%%%%%%%
			Lwheeler(N1,i)=2.34*mu0*N1^2*davg/(1+2.75*rho(N1,i));
			Lcs(N1,i)=(mu0*N1^2*davg/2)*1.27*(log(2.07/rho(N1,i))+0.18*rho(N1,i)+0.13*rho(N1,i)^2);
			Lmon(N1,i)=1.62e-3*((dout*1000000)^-1.21)*((w*1000000)^-0.147)*((davg*1000000)^2.4)*(N1^1.78)*((s*1000000)^-0.03)*1e-9;	
			%%%%%%%%%%
			i=i+1;
		end
	end

waitbar(1,f,'Simulation ended');
rho(rho == 0) = NaN

figure();
hold on;
xlabel('d1')
ylabel('L1')
title('L1');
for i=1:1:range
	plot(rho(i,:), L1(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('R1')
title('R1');
for i=1:1:range
	plot(rho(i,:), R1(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('Q1')
title('Q1');
for i=1:1:range
	plot(rho(i,:), Q1(i,:))
end

delete(f)

