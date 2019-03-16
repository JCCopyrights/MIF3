%% Calculate parameters for Round Inductors.
% Example to try with optimized parameters

addpath('../functions')

N1=30; N2=10;
R1=15e-3; R2=5e-3; d=0.5e-3; h=1.6e-3;
RES=1000;

%X = round_spiral(N1, R1, d, 0, RES, 0, 0, 0, 0, 0, 0);
%Y = round_spiral(N2, R2, d, 0, RES, 0, 0, -R1, 0, 0, 0);
%X = square_spiral(N1,2*R1,2*R1,d,0,0,0,0,0,0);
%Y = square_spiral(N2,2*R2,2*R2,d,0,0,-R1,0,0,0);
X = square_layer_spiral(N1,2*R1,2*R1,d,1,h,0,0,0,0,0,0);
Y = square_layer_spiral(N2,2*R2,4*R2,d,4,h,0,0,-R1,0,0,0);
%Y = square_layer_spiral(N2,2*R2,2*R2,d,4,h,0,0,-R1,0,0,0);
%Y = round_spiral(N2, R1/3, d/6, 0, RES, 0, 0, -R1, 0, 0, 0);
%Y = round_layer_spiral(N2,R2,d,0,RES,4,d,0,0,-R1-d,0,0,0);
%Create the coil structs compatible with FastHenry2
freq=500e3;			%Frequency
w=0.5e-3; h=0.5e-3; %Conductor dimensions
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
primary=generate_coil('primary',X,sigma,w,h,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);
secundary=generate_coil('secundary',Y,sigma,w,h,nhinc,nwinc,rh,rw);
% Package all the coils in a cell array
coils={primary,secundary};

% Visualization of the topology
figure();
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

directives='-o 2 -r 2'; %To Create Spice Models
%directives='';
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,true);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
movefile equiv_circuitROM.spice ..\..\sim %Move the spice model to the simulation folder

disp('Resistance Matrix')
RC=squeeze((R(1,:,:)));
disp(RC);
disp('Inductances Matrix')
LC=squeeze((L(1,:,:)));
disp(LC);

%Calculate COUPLING for each Coil and Frequency
%Coils are numerated in the order of coils={}
disp('Coupling kij between i and j coil')
for j=1:1:size(Frequency,1)
	Indct=squeeze((L(j,:,:)));
	for i=1:1:size(coils,2)
		for l=1:1:size(coils,2)
			k=Indct(i,l)/sqrt(Indct(i,i)*Indct(l,l));
			%Because disp function is shit
			text = sprintf('k%d%d : %g', i,l,k);
			disp(text)
			%Beware of the signs in the couplings,port polarity issues
		end
	end
end
k=Indct(1,2)/sqrt(Indct(2,2)*Indct(1,1));
Q1=2*pi*freq*LC(1,1)/RC(1,1);
Q2=2*pi*freq*LC(2,2)/RC(2,2);
C1=(1/(2*pi*freq*sqrt(LC(1,1))))^2;
C2=(1/(2*pi*freq*sqrt(LC(2,2))))^2;
fact=k^2*Q1*Q2;
fact/((1+sqrt(1+fact))^2)
%save(filename) Saves all the Variables in the Workspace