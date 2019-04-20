%% Optimization for Distance Between Turns
% Iterates different turns and distances for the coils
% For this script visualization of solutions has to be true or it crash....
addpath('../functions')
N1=7;
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;
RES=200;
% 3A 45degree

%Conductor Parameters
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2;				%Relation between discretization filaments
mu0=4*pi*1e-7;			%Permeability
sigma=5.96e7;			%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect

%Fixed Secundary
Y = rectangular_planar_inductor(1,2*r2,4*r2,r2,r2,d2,h,0,0,-r1,0,0,0);
[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);	% Optimize the discretization for each coil
secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);

view=true;

figure();
range=10;
f=waitbar(0,'Initialization');
	for N1=2:1:range
		i=1;
		for d1=2*w1:w1/5:r1/(N1)
			text = sprintf('N1: %i : d1: %g', N1,d1);
			waitbar((N1-2)/range,f,text);
			clf('reset') 
			X = rectangular_planar_inductor(N1,2*r1,2*r1,0,0,d1,h,0,0, 0,0,0,0);
			[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
			coils={primary,secundary};
			if view
				clf('reset') %Reset figure
				hold on;
				plot3(X(1,:),X(2,:),X(3,:));
				plot3(Y(1,:),Y(2,:),Y(3,:));
				grid on
				xlabel('X')
				ylabel('Y')
				zlabel('Z')
				title('WPT Topology');
				legend({primary.coil_name,secundary.coil_name},'Location','east')
				legend('boxoff')
			end
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
			RC=squeeze((R(1,:,:)));
			LC=squeeze((L(1,:,:)));
			L1(N1-1,i)=LC(1,1); L2(N1-1,i)=LC(2,2); M(N1-1,i)=LC(1,2);
			R1(N1-1,i)=RC(1,1); R2(N1-1,i)=RC(2,2);			
			Q1(N1-1,i)=2*pi*freq*L1(N1-1,i)/R1(N1-1,i);
			Q2(N1-1,i)=2*pi*freq*L2(N1-1,i)/R2(N1-1,i);
			k(N1-1,i)=M(N1-1,i)/sqrt(L2(N1-1,i)*L1(N1-1,i));
			%%%%%%%%%%%%
			dout=2*r1+w1;
			s=d1-w1;
			din=dout-(2*N1)*w1-2*(N1-1)*s;
			davg=0.5*(dout+din);
			rho(N1-1,i)=(dout-din)/(dout+din);
			i=i+1;
		end
	end
rho(rho == 0) = NaN;%Delete all non usefull 0
fact=k.^2.*Q1.*Q2;
efic=fact./(1+sqrt(1+fact)).^2;

figure();
hold on;
xlabel('\rho1')
ylabel('\eta')
title('Efficiency');
for i=1:1:range-1
	plot(rho(i,:),efic(i,:))
end

waitbar(1,f,'Simulation ended');

delete(f)
save('../../data/opt_d.mat')%Save all the Variables in the Workspace
