%% Optimize size of Primary
% Example to try with optimized parameters
% For this script visualization of solutions has to be true or it crash....
addpath('../functions')

N_max=3;
r1_max=2*15e-3; r2_max=2*5e-3; d1=2*1e-3;d2=2*0.5e-3;  h=1.6e-3;
r1_min=2e-3;	r2_min=2e-3; r_res=0.5e-3; z=15e-3;
% 3A 45?


%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect
view=true;
if view
	figure();
	f=waitbar(0,'Initialization');
end


r1_len=length(r1_min:r_res:r1_max);
r2_len=length(r2_min:r_res:r2_max);
for N=1:1:N_max
	i=1;
	for r1=r1_min:r_res:r1_max
		j=1;
		for r2=r2_min:r_res:r2_max
			c=(N~=1)*h;%Compensate the inductor height
			X = rectangular_planar_inductor(N,2*r1,2*r1,0,0,1e-3,h,0,0, c,0,0,0);
			Y = rectangular_planar_inductor(N,2*r2,4*r2,0,0,1e-3,h,0,0,-z,0,0,0);
			%X = circular_planar_inductor(N,2*r1,0,0,0,1e-3,RES,h,0,0,c,0,0,0);
			%Y = circular_planar_inductor(N,2*r2,0,0,0,1e-3,RES,h,0,0,-z,0,0,0);
			% Optimize the discretization for each coil
			[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w2,h2,nhinc,nwinc,rh,rw);
			[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
			secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);
			% Package all the coils in a cell array
			coils={primary,secundary};
			% Visualization of the topology
			if view
				text = sprintf('N: %i r1: %g : r2: %g',N,r1,r2);
				waitbar(((N-1)*r2_len*r1_len+(i-1)*r2_len+(j-1))/(N_max*r1_len*r2_len),f,text);
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
			%directives='-o 2 -r 2'; %To Create Spice Models
			directives='';
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,true);
			LC=squeeze((L(1,:,:)));
			RC=squeeze((R(1,:,:)));
			R1(N,i,j)=RC(1,1); R2(N,i,j)=RC(2,2);
			L1(N,i,j)=LC(1,1); L2(N,i,j)=LC(2,2); M(N,i,j)=LC(1,2);
			Q1(N,i,j)=2*pi*freq*L1(N,i,j)/R1(N,i,j);
			Q2(N,i,j)=2*pi*freq*L2(N,i,j)/R2(N,i,j);
			k(N,i,j)=M(N,i,j)/sqrt(L2(N,i,j)*L1(N,i,j));
			j=j+1;
		end
		i=i+1;
	end
end

fact=k.^2.*Q1.*Q2;
efic=fact./(1+sqrt(1+fact)).^2;

figure();
hold on;
grid on;
xlabel('r1')
ylabel('\eta')
title('\eta');
for i=1:1:r2_len
	plot(r1_min:r_res:r1_max,squeeze(efic(1,:,i)))
end
saveas(gcf,'../../data/graph/opt_R_eta','svg');

figure();
hold on;
grid on;
xlabel('r1')
ylabel('K')
title('K');
for i=1:1:r2_len
	plot(r1_min:r_res:r1_max,squeeze(k(1,:,i)))
end
saveas(gcf,'../../data/graph/opt_R_k','svg');

figure();
hold on;
grid on;
xlabel('r1')
ylabel('Q1')
title('Q1');
for i=1:1:r2_len
	plot(r1_min:r_res:r1_max,squeeze(Q1(1,:,i)))
end
saveas(gcf,'../../data/graph/opt_R_Q1','svg');





waitbar(1,f,'Simulation ended');
delete(f)
save('../../data/opt_R.mat')%Save all the Variables in the Workspace











