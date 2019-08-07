%% Final Results for WPT topology
% Example to try with optimized parameters

addpath('../functions')

N1=6; N2=8;
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;
z=7.5e-3;
RES=200;
% 3A 45?
%Nmax=r1/(d1*2)
%c=(N>Nmax)*h;%Compensate the inductor height
X = rectangular_planar_inductor(N1,2*r1,2*r1,r1,r1,d1,h,0,0, h,0,0,0);
Y = rectangular_planar_inductor(N2,2*r2,4*r2,r2,r2,d2,h,0,0,-z,0,0,0);
%X = circular_planar_inductor(N1,r1,r1/2,d1,0,RES,h,0,0,h,0,0,0);
%Y = circular_planar_inductor(N2,r2,r2/2,d2,0,RES,h,0,0,-z,0,0,0);
%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization for each coil (In this case is not necesary, equal w,h for every coil)
% This Parameter affects A LOT simulation times
[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);
primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);
secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);
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

export_spice=false;
if export_spice
	directives='-o 2 -r 2'; %To Create Spice Models
else
	directives='';
end
%directives='-i2';
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,false);
%[C]=fastcap2_runner( fastcap2_creator('SurpriseMotherFucker.inp','SurpriseMotherFucker',4.4, '-d1 -e0.1 -f'),'-o40 -p1',true);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

if export_spice
	movefile equiv_circuitROM.spice ..\..\sim %Move the spice model to the simulation folder
end


disp('Resistance Matrix')
RC=squeeze((R(1,:,:)));
disp(RC);
disp('Inductances Matrix')
LC=squeeze((L(1,:,:)));
disp(LC);
disp('Capacitance Matrix')
%disp(C);
R1=RC(1,1); R2=RC(2,2);
L1=LC(1,1); L2=LC(2,2); M=LC(1,2);
Ro=13.69*4/pi;

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
Vin=4/pi*3.7;
k=M/sqrt(L2*L1);
Q1=2*pi*freq*L1/R1;
Q2=2*pi*freq*L2/R2;
C1=(1/(2*pi*freq*sqrt(L1)))^2;
C2=(1/(2*pi*freq*sqrt(L2)))^2;
fact=k^2*Q1*Q2;
opRo=R2*sqrt(1+fact);
opRe=(2*pi*freq*M)^2./(R2+opRo);
maxef=opRo*opRe/((R2+opRo)*(R1+opRe))
opPout=opRo*opRe*Vin^2/((R2+opRo)*((R1+opRe)^2))
Ro=linspace(1,100,1000);
Re=(2*pi*freq*M)^2./(R2+Ro);
I1=Vin./(R1+Re);
I2=I1*2*pi*freq*M./(R2+Ro);
Pout=Ro.*Re*Vin^2./((R2+Ro).*((R1+Re).^2));
Pin=Vin^2./(R1+Re);
efic=Ro.*Re./((R2+Ro).*(R1+Re));
Vout=Ro.*I2;
save('../../data/WPT.mat')%Save all the Variables in the Workspace









