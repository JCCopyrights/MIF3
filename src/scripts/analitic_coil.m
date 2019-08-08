addpath('../functions')
%Geometry
w1=1e-3; h1=0.0347e-3;		%Conductor dimensions
R=15e-3; d=2*w1;	h=1.6e-3;	%Coil Size
N=6;						%Turns
layers=2;
X = rectangular_planar_inductor(N,2*R,2*R,R,R,d,h,0,0,0,0,0,0);
%Materials
freq=6.79e6;			%Frequency
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect
% Optimize the discretization 
[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta/2);
primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
% Package all the coils in a cell array
coils={primary};
% Visualization of the topology
figure();
hold on;
plot3(X(1,:),X(2,:),X(3,:),'LineWidth',2);
grid on
grid minor
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Inductor N6');
%legend({primary.coil_name},'Location','east')
%legend('boxoff')
%%%%%%%%%%%%%%%%%%%%%%%%
%%FASTHENRYV2 SIMULATION
directives='';
%directives='-i2';
tic;
[L_fh,R_fh,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,false);
toc;
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
disp('FastHenry Resistance Matrix')
RC=squeeze((R_fh(1,:,:)));
disp(RC);
disp('FastHenry Inductances Matrix')
LC=squeeze((L_fh(1,:,:)));
disp(LC);
R1=RC(1,1);
L1=LC(1,1);
%%%%%%%%%%%%%%%%%%%%%%%%
%%ANALYTICAL SIMULATION
tic;
N_l=N/layers;
s=d-w1;						%Space between conductors
dout=2*R+w1;					%External diameter
din=2*R-2*(N_l-1)*d-w1;		%Internal diameter
d_avg=0.5*(dout+din);		%Average diameter
rho=(dout-din)/(dout+din);	%Fill factor
c1=1.27; c2=2.07; c3=0.18; c4=0.13; %parameters
L=(mu0*N_l^2*d_avg*c1/2*(log(c2/rho)+c3*rho+c4*rho^2));
A=0.184; B=-0.525; C=1.038; D=1.001;
k=N^2/(0.64*(A*(h*1000)^3+B*(h*1000)^2+C*(h*1000)+D)*(1.67*N^2-5.584*N+65)); %Distance h in mm
M_aprox=k*L;
Ltotal=layers*L+2*M_aprox;
long=primary.length;
p=sqrt(w1*h1)/(1.26*delta);
%Ff=1-exp(-0.048*p);%Haefner
Ff=1-exp(-0.026*p); %Payne
%Kc=1+Ff*(0.06+0.22*log(w1/h1)+0.28*h1^2/w1); %Haefner
Kc=1+Ff*(1.2/exp(2.1*w1/h1)+1.2/exp(2.1*h1/w1));%Payne
%xc=2*delta*(1/h1+1/w1); %Haefner
xc=(2*delta*(1/h1+1/w1)+8*(delta/h1)^3/(w1/h1))/(((w1/h1)^0.33)*exp(-3.5*h1/delta)+1);%Payne
Rac=(long/(sigma*w1*h1))*(Kc/(1-exp(-xc))); %Crowding effect
Rdc=(long/(sigma*w1*h1));
toc;
disp('Analytical Resistance Matrix')
disp(Rac);
disp('Analytical Inductances Matrix')
disp(Ltotal);
