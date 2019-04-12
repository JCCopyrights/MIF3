%% Optimization of Inductors for different prohibition sizes
% Iterates different turns and prohibition zones for the coils

addpath('../functions')
N1=3*4;
r1=5e-3; d1=2*0.5e-3; h=1.6e-3;

%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=0.5e-3; h1=0.309e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect

figure();
range=N1;
f=waitbar(0,'Initialization');
	j=1;
	for N1=1:1:range
		i=1;
		for A0=0:2*d1:2*r1-2*d1
			text = sprintf('N1: %i : A0: %g', N1,A0);
			waitbar(N1/range,f,text);
			clf('reset') 
			X = rectangular_planar_inductor(N1,2*r1,4*r1,A0,A0,d1,h,0,0, 0,0,0,0,true);
			[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
			coils={primary};
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
			Rs=squeeze((R(1,:,:)));
			Ls=squeeze((L(1,:,:)));
			R1(j,i)=Rs(1,1);
			L1(j,i)=Ls(1,1);
			Q1(j,i)=2*pi*freq*Ls(1,1)/Rs(1,1);
			i=i+1;
		end
		j=j+1;
	end
waitbar(1,f,'Simulation ended');
save('../../data/opt_A0.mat')%Save all the Variables in the Workspace


figure();
hold on;
xlabel('d1')
ylabel('L1')
title('L1');
for i=1:1:range
	plot(L1(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('R1')
title('R1');
for i=1:1:range
	plot(R1(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('Q1')
title('Q1');
for i=1:1:range
	plot(Q1(i,:))
end

delete(f)

