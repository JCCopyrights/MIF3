%% Inductance Calculation.
% Compares simulated inductance with Mohan theoretical data

addpath('../functions')

%Data set from Mohan Paper
%diam=(180-1.6)/1000000;
%N=12;
%d=5.3/1000000;
%w=3.2/1000000;
%http://www.circuits.dk/calculator_planar_coil_inductor.htm


diam=580e-3;
N=15;
d=18e-3;
w=6e-3; h=6e-3;%Conductor dimensions

%Parameters to apply Mohan equations
s=d-w; %Distance between turns
dout=diam+w/2;
din=dout-(2*N)*w-2*(N-1)*s;
davg=0.5*(dout+din);
rho=(dout-din)/(dout+din);

X = square_spiral(N,diam,diam,d,0,0,0,0,0,0, true);

freq=100e3; 		%Frequency
rh=10; rw=10; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.96e7; 		%Conductivity
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); 		%Skin effect
[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta);	%Optimize filament number
inductor=generate_coil('primary',X,sigma,w,h,nhinc,nwinc,rh,rw);
coils={inductor};

[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

%Simple Accurate Expressions for Planar Spiral Inductances - Mohan
Lwheeler=2.34*mu0*N^2*davg/(1+2.75*rho);
Lcs=(mu0*N^2*davg/2)*1.27*(log(2.07/rho)+0.18*rho+0.13*rho^2);
Lmon=1.62e-3*((dout*1000000)^-1.21)*((w*1000000)^-0.147)*((davg*1000000)^2.4)*(N^1.78)*((s*1000000)^-0.03)*1e-9;
L=squeeze((L(1,:,:)));
disp('Inductance Test')
text = sprintf('Lwheeler : %g', Lwheeler);
disp(text)
text = sprintf('Lcs : %g', Lcs);
disp(text)
text = sprintf('Lmon : %g', Lmon);
disp(text)
text = sprintf('LFastHenry : %g', L);
disp(text)

% Very simple resistivity calculation. Very bad results
disp('Resistance Test')
length=0;
for i=1:1:size(X,2)-1
	E=(X(:,i+1)-X(:,i))/1000;
	length=length+sqrt(E(1)^2+E(2)^2+E(3)^2);
end
Rdc=(1/sigma)*length/(w^2);
Rac=length*(1/sigma)/(pi*w*delta); %Una u otra en teoria
R=squeeze((R(1,:,:)));
Rstimated=max(Rdc,Rac);
text = sprintf('Restim : %g', Rstimated);
disp(text);
text = sprintf('RFastHenry : %g', R);
disp(text);