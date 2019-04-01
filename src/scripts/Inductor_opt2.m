%% Optimizaton Process for Round Inductors.
% Iterates different turns and distances for the coils

addpath('../functions')
N1=7;
r1=15e-3;d1=2*1e-3; h=1.6e-3;
RES=200;
% 3A 45degree

%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.309e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect

figure();
range=10;
f=waitbar(0,'Initialization');
	j=1;
	for N1=1:1:range
		i=1;
		for A0=0:2*d1:2*r1-2*d1
			text = sprintf('N1: %i : A0: %g', N1,A0);
			waitbar(N1/range,f,text);
			clf('reset') 
			X = rectangular_planar_inductor(N1,2*r1,2*r1,A0,A0,d1,h,0,0, 0,0,0,0,true);
			[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
			coils={primary};
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
			Rs=squeeze((R(1,:,:)));
			Ls=squeeze((L(1,:,:)));
			R1(j,i)=Rs(1,1);
			L1(j,i)=Ls(1,1);
			Q1(j,i)=2*pi*freq*Ls(1,1)/Rs(1,1);
			%%%%%%%%%%%%
			dout=2*r1+w1/2;
			s=d1-w1;
			din=dout-(2*N1)*w1-2*(N1-1)*s;
			davg=0.5*(dout+din);
			rho(j,i)=(dout-din)/(dout+din);
			%%%%%%%%%%%%
			Lwheeler(j,i)=2.34*mu0*N1^2*davg/(1+2.75*rho(N1,i));
			Lcs(j,i)=(mu0*N1^2*davg/2)*1.27*(log(2.07/rho(N1,i))+0.18*rho(N1,i)+0.13*rho(N1,i)^2);
			Lmon(j,i)=1.62e-3*((dout*1000000)^-1.21)*((w1*1000000)^-0.147)*((davg*1000000)^2.4)*(N1^1.78)*((s*1000000)^-0.03)*1e-9;	
			%%%%%%%%%%
			i=i+1;
		end
		j=j+1;
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

