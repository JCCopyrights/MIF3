%% Optimizaton Process for Round Inductors.
% Iterates different turns and distances for the coils

addpath('../functions')
N1=10; d1=0.5e-3;
N2=5; d2=1e-3;
D1=30e-3; D2= 10e-3; z=15e-3; RES=400;

%Create the coil structs compatible with FastHenry2
freq=500e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=10; rw=10; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect
figure();
range=20;
L1_rnd=zeros(range-1,76); L2_rnd=zeros(range-1,76); k_rnd=zeros(range-1,76);
R1_rnd=zeros(range-1,76); R2_rnd=zeros(range-1,76);
f=waitbar(0,'Initialization');
for N1=2:1:range
	i=1;
	for d1=w:w:15e-3/N1
		text = sprintf('N1: %i : d1: %g', N1,d1);
		waitbar(N1/range,f,text);
		clf('reset') 
		hold on;
		X = round_spiral(N1, D1/2, d1, 0, RES, 0, 0, 0, 0, 0, 0,true);
		Y = round_spiral(N2, D2/2, d2, 0, RES, 0, 0, -z, 0, 0, 0,true);
		[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
		primary=generate_coil('primary',X,sigma,w,h,nhinc,nwinc,rh,rw);
		[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
		secundary=generate_coil('secundary',Y,sigma,w,h,nhinc,nwinc,rh,rw);
		coils={primary,secundary};
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
		%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
		Rs=squeeze((R(1,:,:)));
		Ls=squeeze((L(1,:,:)));
		R1_rnd(N1-1,i)=Rs(1,1);
		R2_rnd(N1-1,i)=Rs(1,1);
		L1_rnd(N1-1,i)=Ls(1,1);
		L2_rnd(N1-1,i)=Ls(2,2);
		k_rnd(N1-1,i)=Ls(1,2)/sqrt(Ls(1,1)*Ls(2,2));
		i=i+1;
	end
end
waitbar(1,f,'Simulation ended');
Q1_rnd=2*pi*freq*L1_rnd./R1_rnd;
Q2_rnd=2*pi*freq*L2_rnd./R2_rnd;

figure();
hold on;
xlabel('d1')
ylabel('K')
title('K Coupling');
for i=1:1:19
	plot(k_rnd(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('K')
title('L1');
for i=1:1:19
	plot(L1_rnd(i,:))
end
figure();
hold on;
xlabel('d1')
ylabel('kQ1Q2')
title('Efficiency');
for i=1:1:19
	plot(Q1_rnd(i,:))
end


figure();
hold on;
xlabel('d1')
ylabel('kQ1Q2')
title('Efficiency');
for i=1:1:19
	eff=k_rnd.*Q1_rnd.*Q2_rnd(i,:);
	plot(eff(i,:))
end



delete(f)

