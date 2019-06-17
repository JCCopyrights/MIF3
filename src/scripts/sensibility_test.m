%% Spatial Sensibility Test
% Modify alignment between coils in x,y,z, to calculate eficiency variations

addpath('../functions')

y_min=-10e-3; y_max=10e-3; 
x_min=-10e-3; x_max=10e-3; 
z_min=5e-3; z_max=25e-3; 
res=5e-3; 
%Coil Dimensions
N1=2; N2=2;
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;

%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.8e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect
view=true;
if view
	figure();
	f=waitbar(0,'Initialization');
end

m=1;
for z=z_min:res:z_max
	i=1;
	for x=x_min:res:x_max
		j=1;
		for y=y_min:res:y_max
			c=(N~=1)*h;%Compensate the inductor height
			X = rectangular_planar_inductor(N1,2*r1,2*r1,0,0,1e-3,h,x,y,z+c,0,0,0);
			Y = rectangular_planar_inductor(N2,2*r2,4*r2,0,0,1e-3,h,0,0,-z,0,0,0);
			% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
			% This Parameter affects A LOT simulation times
			[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
			primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
			[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
			secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);
			% Package all the coils in a cell array
			coils={primary,secundary};
			% Visualization of the topology
			if view
				text = sprintf('x: %g y: %g : z: %g',x,y,z);
				waitbar(z/z_max,f,text);
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
			[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,false);
			LC=squeeze((L(1,:,:)));
			RC=squeeze((R(1,:,:)));
			R1(m,i,j)=RC(1,1); R2(m,i,j)=RC(2,2);
			L1(m,i,j)=LC(1,1); L2(m,i,j)=LC(2,2); M(m,i,j)=LC(1,2);
			Q1(m,i,j)=2*pi*freq*L1(m,i,j)/R1(m,i,j);
			Q2(m,i,j)=2*pi*freq*L2(m,i,j)/R2(m,i,j);
			k(m,i,j)=M(m,i,j)/sqrt(L2(m,i,j)*L1(m,i,j));
			j=j+1;
		end
		i=i+1;
	end
	m=m+1;
end
waitbar(1,f,'Simulation ended');
save('../../data/sensibility_test.mat')%Save all the Variables in the Workspace
delete(f)












