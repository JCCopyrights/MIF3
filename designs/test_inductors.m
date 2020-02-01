%% Test Inductors:
%This script takes data imported from bode100 processes it and compares it to analytical an MIF3 solutions

type=["L1N06AW","L1N06TW","L1N12AW","L1N12TW","L2N08AW","L2N08TW","L2N04AW","L2N04TW",];

%COIL DATA
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; hh=1.6e-3;
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.0347e-3; %Conductor dimensions 1OZ
w2=0.5e-3; h2=0.0347e-3; %Conductor dimensions 1OZ
rh=2; rw=2; 		%Relation between discretization filaments
mu0=4*pi*1e-7; 		%Permeability
sigma=5.8e7;			%Conductivity (rho=2e-8)
delta=sqrt(2*(1/sigma)/(2*pi*freq*mu0)); %Skin effect

resolution=1;

for i=1:1:length(type)
	type_aux=char(type(i));
	check(i).name=type(i);
	for j=1:1:3
		filename=strcat(type(i),'_',num2str(j),'.csv');
		aux_data(j)=import_bode100(filename);
	end
	
	%Compare every TW with AW
	if(mod(i,2)==1)
		imp=figure;
		sgtitle(type_aux(1:5));
	end
	
	%filename=strcat(type(i),'_','1','.csv')
	%data=import_bode100(filename);
	%%Calculate the mean of 3 PCBs
	data.name=type(i);
	data.raw.f=aux_data(1).raw.f;
	data.raw.Z=(aux_data(1).raw.Z+aux_data(2).raw.Z+aux_data(3).raw.Z)/3;
	data.raw.theta=(aux_data(1).raw.theta+aux_data(2).raw.theta+aux_data(3).raw.theta)/3;
	data.raw.Ls=(aux_data(1).raw.Ls+aux_data(2).raw.Ls+aux_data(3).raw.Ls)/3;
	data.raw.Rs=(aux_data(1).raw.Rs+aux_data(2).raw.Rs+aux_data(3).raw.Rs)/3;
	data.raw.Q=(aux_data(1).raw.Q+aux_data(2).raw.Q+aux_data(3).raw.Q)/3;
	%%Plot
	figure(imp)
	subplot(2,2,1);
	loglog(data.raw.f,data.raw.Z,'LineWidth',1.5);
	hold on;
	grid on;
	xlabel('f(Hz)');
	ylabel('Z(\Omega)');
	title('Impedancia');
	legend({'AW','TW'},'Location','southeast');
	legend('boxoff')
	subplot(2,2,2);
	semilogx(data.raw.f,data.raw.Q,'LineWidth',1.5);
	grid on;
	hold on;
	xlabel('f(Hz)');
	ylabel('Q');
	title('Factor de Calidad');
	legend({'AW','TW'},'Location','southeast');
	legend('boxoff')
	subplot(2,2,3);
	semilogx(data.raw.f,data.raw.Ls,'LineWidth',1.5);
	grid on;
	hold on;
	xlabel('f(Hz)');
	ylabel('Inductancia (H)');
	title('Ls');
	legend({'AW','TW'},'Location','southeast');
	legend('boxoff')
	subplot(2,2,4);
	loglog(data.raw.f,data.raw.Rs,'LineWidth',1.5);
	grid on;
	hold on;
	xlabel('f(Hz)');
	ylabel('Rs(\Omega)');
	title('Rs');
	legend({'AW','TW'},'Location','southeast');
	legend('boxoff')
	
	%%Create model and shit
	disp(type(i))
	model=model_bode100(data,100e3);
	%figure(imp)
	%loglog(data.raw.f,abs(model.Z));
	%Value Extraction
	freq_op=6.79e6;
	
	[ trash, i_aprox ] = min(abs( data.raw.f-freq_op));
	f_aprox=data.raw.f(i_aprox);
	text=sprintf('Aproximating f=%i to f_aprox=%i',freq_op,f_aprox); %Because disp function sucks dick.
	disp(text);
	check(i).data_L=model.L(i_aprox);
	check(i).data_R=model.R(i_aprox);
	check(i).data_Cp=model.Cp(i_aprox);
	check(i).data_f_res=model.f_res;
	
	%% MIF3 FastHenry
		N=str2num(type_aux(4:5));
	if string(type_aux(1:2))=='L1' %Primary
		N_l=floor(r1/(2*d1));
		layers= N/N_l;
		if layers==2
			hh=0.185e-3+1.15e-3+0.185e-3;
		else
			hh=[0.185e-3,1.15e-3,0.185e-3];
		end
		%hh=[0.185,1.15,0.185];
		%Fast Henry
		X = rectangular_planar_inductor(N,2*r1,2*r1,r1,r1,d1,hh,0,0,0,0,0,0);
		[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta/resolution);
		coil_struct=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
		% Analytical
		w=w1; h=h1;
		d=d1; r=r1;
	else	%Secundary
		N_l=floor(r2/(2*d2)); %Turns per layer
		layers= N/N_l;	
		if layers==2
			hh=0.185e-3+1.15e-3+0.185e-3;
		else
			hh=[0.185e-3,1.15e-3,0.185e-3];
		end
		%Fast Henry
		X = rectangular_planar_inductor(N,2*r2,4*r2,r2,r2,d2,hh,0,0,0,0,0,0);
		[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta/resolution);
		coil_struct=generate_coil('secundary',X,sigma,w2,h2,nhinc,nwinc,rh,rw);
		%Analytical
		w=w2; h=h2;
		d=d2; r=1.5*r2; %Rectangular...
	end 
	coils={coil_struct};
	tic;
	[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
	check(i).FH_time=toc;
	check(i).FH_L=L;
	check(i).FH_R=R;
	check(i).FH_Q=2*pi*freq*L/R;
	check(i).err_L=(check(i).FH_L-check(i).data_L)/check(i).data_L*100;
	check(i).err_R=(check(i).FH_R-check(i).data_R)/check(i).data_R*100;
	
	%%Analytical
	tic;
	s=d-w;						%Space between conductors
	dout=2*r+w;					%External diameter
	din=2*r-2*(N_l-1)*d-w;		%Internal diameter
	d_avg=(dout+din)/2;		%Average diameter
	rho=(dout-din)/(dout+din);	%Fill factor
	c1=1.27; c2=2.07; c3=0.18; c4=0.13; %parameters
	L=(mu0*N_l^2*d_avg*c1/2*(log(c2/rho)+c3*rho+c4*rho^2));
	%A=0.184; B=-0.525; C=1.038; D=1.001;
	%k=N^2/((A*(h)^3+B*(h)^2+C*(h)+D)*(1.67*N^2-5.584*N+65)*0.64); %Distance h in mm
	%k=N^2/(0.64*(A*(h*1000)^3+B*(h*1000)^2+C*(h*1000)+D)*(1.67*N^2-5.584*N+65)); %% This hould be orrect, beause the paper, BUT NO?
	k=1;
	M_aprox=k*L;
	Ltotal=layers*L+2*(factorial(layers)/(2*factorial(layers-2)))*M_aprox; %Combinatory
	long=coil_struct.length;
	p=sqrt(w*h)/(1.26*delta);
	%Ff=1-exp(-0.048*p);%Haefner
	Ff=1-exp(-0.026*p); %Payne
	%Kc=1+Ff*(0.06+0.22*log(w/h)+0.28*h^2/w); %Haefner
	Kc=1+Ff*(1.2/exp(2.1*w/h)+1.2/exp(2.1*h/w));%Payne
	%xc=2*delta*(1/h+1/w); %Haefner
	xc=(2*delta*(1/h+1/w)+8*(delta/h)^3/(w/h))/(((w/h)^0.33)*exp(-3.5*h/delta)+1);%Payne
	Rac=(long/(sigma*w*h))*(Kc/(1-exp(-xc))); %Crowding effect
	Rdc=(long/(sigma*w*h));
	check(i).AN_time=toc;
	check(i).AN_L=Ltotal;
	check(i).AN_Rdc=Rdc;
	check(i).AN_R=Rac;
	check(i).AN_Q=2*pi*freq*Ltotal/Rac;
	check(i).err_ANL=(check(i).AN_L-check(i).data_L)/check(i).data_L*100;
	check(i).err_ANR=(check(i).AN_R-check(i).data_R)/check(i).data_R*100;
end