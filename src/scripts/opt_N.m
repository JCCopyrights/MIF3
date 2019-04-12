%% Optimize number of turns
% Iterate every turn up to 4 layers for primary and secundary

addpath('../functions')

%Coil Dimensions
N1=7; N2=5;
r1=15e-3; r2=5e-3; d1=2*1e-3;d2=2*0.5e-3; h=1.6e-3;
RES=200;
range_N1=4*2;
range_N2=4*2;
% 3A 45degree

%Create the coil structs compatible with FastHenry2
freq=6.79e6;			%Frequency
w1=1e-3; h1=0.309e-3;	%Conductor dimensions 1OZ
w2=0.5e-3; h2=0.309e-3; %Conductor dimensions 1OZ
rh=2; rw=2;				%Relation between discretization filaments
mu0=4*pi*1e-7;			%Permeability
sigma=5.96e7;			%Conductivity
delta=sqrt(2*(1/5.8e7)/(2*pi*freq*mu0)); %Skin effect

%Converter Propierties
Ro=13.69*4/pi;
Vin=4/pi*3.7;

%Visualization
figure();
f=waitbar(0,'Initialization');

i=1;
for N1=1:1:range_N1
	j=1;
	for N2=1:1:range_N2
		text = sprintf('N1: %i : N2: %g', N1,N2);
		waitbar(((N1-1)*range_N2+N2)/(range_N1*range_N2),f,text);
		X = rectangular_planar_inductor(N1,2*r1,2*r1,r1,r1,d1,h,0,0, h,0,0,0);
		Y = rectangular_planar_inductor(N2,2*r1,2*r1,r1,r1,d2,h,0,0,-r1,0,0,0);
		[nhinc,nwinc]=optimize_discr(w1,h1,rh,rw,delta);	% Optimize the discretization for each coil
		primary=generate_coil('primary',X,sigma,w1,h1,nhinc,nwinc,rh,rw);
		[nhinc,nwinc]=optimize_discr(w2,h2,rh,rw,delta);	% Optimize the discretization for each coil
		secundary=generate_coil('secundary',Y,sigma,w2,h2,nhinc,nwinc,rh,rw);
		% Package all the coils in a cell array
		coils={primary,secundary};
		% Visualization of the topology
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
		% FEA Analysis
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
		%Obtain DATA
		LC=squeeze((L(1,:,:)));
		RC=squeeze((R(1,:,:)));
		view=false; %Print the parameters for each iteration
		if view
			disp('Resistance Matrix')
			disp(RC);
			disp('Inductances Matrix')
			disp(LC);
		end
		R1(i,j)=RC(1,1); R2(i,j)=RC(2,2);
		L1(i,j)=LC(1,1); L2(i,j)=LC(2,2); M(i,j)=LC(1,2);
		k(i,j)=M(i,j)/sqrt(L2(i,j)*L1(i,j));
		Q1(i,j)=2*pi*freq*L1(i,j)/R1(i,j);
		Q2(i,j)=2*pi*freq*L2(i,j)/R2(i,j);
		%% Circuit Analysis
		fact(i,j)=k(i,j)^2*Q1(i,j)*Q2(i,j);
		opRo(i,j)=R2(i,j)*sqrt(1+fact(i,j));
		opRe(i,j)=(2*pi*freq*M(i,j))^2/(R2(i,j)+opRo(i,j));
		opPout(i,j)=opRo(i,j)*opRe(i,j)*Vin^2/((R2(i,j)+opRo(i,j))*((R1(i,j)+opRe(i,j))^2))
		opefic(i,j)=opRo(i,j)*opRe(i,j)/((R2(i,j)+opRo(i,j))*(R1(i,j)+opRe(i,j)))
		opI1(i,j)=Vin/(R1(i,j)+opRe(i,j));
		opI2(i,j)=opI1(i,j)*2*pi*freq*M(i,j)/(R2(i,j)+opRo(i,j))
		opVout(i,j)=opRo(i,j)*opI2(i,j)
		Re(i,j)=(2*pi*freq*M(i,j))^2/(R2(i,j)+Ro);
		I1(i,j)=Vin/(R1(i,j)+Re(i,j))
		I2(i,j)=I1(i,j)*2*pi*freq*M(i,j)/(R2(i,j)+Ro)
		Pout(i,j)=Ro*Re(i,j)*Vin^2/((R2(i,j)+Ro)*((R1(i,j)+Re(i,j))^2))
		Pin(i,j)=Vin^2/(R1(i,j)+Re(i,j))
		efic(i,j)=Ro*Re(i,j)/((R2(i,j)+Ro)*(R1(i,j)+Re(i,j)))
		Vout(i,j)=Ro*I2(i,j)
		j=j+1;
	end
	i=i+1;
end
waitbar(1,f,'Simulation ended');
save('../../data/opt_N_4layer.mat')%Save all the Variables in the Workspace

figure();
hold on;
xlabel('N2')
ylabel('W')
title('Optimal Power');
for i=1:1:size(opPout,1)
	plot(opPout(i,:))
end
figure();
hold on;
xlabel('N2')
ylabel('maxef')
title('maxef');
for i=1:1:size(opefic,1)
	plot(opefic(i,:))
end


delete(f)