%% Optimization of Inductors for different prohibition sizes
% Iterates different turns and prohibition zones for the coils

addpath('../functions')
N1=3*4; N2=4;
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;
z=15e-3;

%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.8e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect

Y = rectangular_planar_inductor(N2,2*r2,4*r2,r2,r2,d2,h,0,0,-z,0,0,0);
[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);

figure();
range=N1;
f=waitbar(0,'Initialization');
i=1;
r1_len=length(5e-3:2.5e-3:20e-3);
for r1=5e-3:2.5e-3:20e-3	
	j=1;
	for N1=1:1:r1/(d1)
		text = sprintf('N1: %i', N1);
		waitbar(i/r1_len,f,text);
		clf('reset') 
		X = rectangular_planar_inductor(N1,2*r1,2*r1,0,0,d1,h,0,0, 0,0,0,0,true);
		[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
		primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
		coils={primary,secundary};
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
		[C]=fastcap2_runner( fastcap2_creator('SurpriseMotherFucker.inp','SurpriseMotherFucker',1, '-d0.1'),'-o50 -p4.4',false);
		Rs=squeeze((R(1,:,:)));
		Ls=squeeze((L(1,:,:)));
		R1(i,j)=Rs(1,1); R2=Rs(2,2);
		L1(i,j)=Ls(1,1); L2(i,j)=Ls(2,2); M(i,j)=Ls(1,2);
		Q1(i,j)=2*pi*freq*Ls(1,1)/Rs(1,1);
		Q2(i,j)=2*pi*freq*Ls(2,2)/Rs(2,2);
		C1(i,j)=C(1,1)+C(1,2);
		C2(i,j)=C(2,2)+C(1,2);
		%%%%%%%%%%%%
		dout=2*r1+w1;
		s=d1-w1;
		din=dout-(2*N1)*w1-2*(N1-1)*s;
		davg=0.5*(dout+din);
		rho(i,j)=(dout-din)/(dout+din);
			
		j=j+1;
	end
	i=i+1;
end
k=M./sqrt(L2.*L1);
fact=k.^2.*Q1.*Q2;
efic=fact./(1+sqrt(1+fact)).^2;
rho(rho == 0) = NaN;%Delete all non usefull 0
waitbar(1,f,'Simulation ended');

linewidth=1.5;
figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('\eta')
title('\eta');
for i=1:1:size(rho,1)
	plot(rho(i,:),efic(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_eta','svg');

figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('k')
title('k');
for i=1:1:size(rho,1)
	plot(rho(i,:),k(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_k','svg');

figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('Q1')
title('Q1');
for i=1:1:size(rho,1)
	plot(rho(i,:),Q1(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_Q1','svg');

figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('R1')
title('R1');
for i=1:1:size(rho,1)
	plot(rho(i,:),R1(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_R1','svg');

figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('L1')
title('L1');
for i=1:1:size(rho,1)
	plot(rho(i,:),L1(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_L1','svg');

figure();
hold on;
grid on;
xlabel('\rho(N1)')
ylabel('C1')
title('C1');
for i=1:1:size(rho,1)
	plot(rho(i,:),C1(i,:),'LineWidth',linewidth)
end
saveas(gcf,'../../data/graph/opt_a0_c1','svg');

delete(f)
save('../../data/opt_A0.mat')%Save all the Variables in the Workspace



