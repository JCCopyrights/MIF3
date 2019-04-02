%% Calculate parameters for Round Inductors.
% Example to try with optimized parameters

addpath('../functions')

N1=1;	%7 per layer
N2=1;	%5 per layer
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;
RES=200;
% 3A 45?
X = rectangular_planar_inductor(N1,2*r1,2*r1,r1,r1,d1,h,0,0, h,0,0,0);
%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.309e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.309e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
range=10;
j=1;
figure();
f=waitbar(0,'Initialization');
long=size(0:2*d2:2*r2-2*d2,2);
for N2=1:1:range
	i=1;
	for A0=0:2*d2:2*r2-2*d2	
		text = sprintf('N2: %i : A0: %g', N2,A0);
		waitbar(((N2-1)*long+i)/(range*long),f,text);
		Y = rectangular_planar_inductor(N2,2*r2,4*r2,A0,A0,d2,h,0,0,-r1,0,0,0);
		[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
		secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);
		% Package all the coils in a cell array
		coils={primary,secundary};
		% Visualization of the topology
		clf('reset') 
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

		%directives='-o 2 -r 2'; %To Create Spice Models
		directives='';
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,false);
		%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
		%movefile equiv_circuitROM.spice ..\..\sim %Move the spice model to the simulation folder

		%%%%%%%
		RC=squeeze((R(1,:,:)));
		LC=squeeze((L(1,:,:)));
		R1(j,i)=RC(1,1); R2(j,i)=RC(2,2);
		L1(j,i)=LC(1,1); L2(j,i)=LC(2,2); M(j,i)=LC(1,2);
		k(j,i)=M(j,i)/sqrt(L1(j,i)*L2(j,i));
		i=i+1;
	end
	j=j+1;
end









