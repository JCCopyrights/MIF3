
addpath('../functions');

freq=6.79e6;
T=1/freq;
w=2*pi*freq;
periods=100;
R0=8;
R0_mod=linspace(1,100,100);
L2=1.435e-6;
C2=1/(w^2*L2)*1e9;
C2_mod=linspace(0.8*C2,1.2*C2,50);
file_name='WPT_inv_rect.asc';
wait=waitbar(0,'Initialization');
for cycles_C2=1:1:length(C2_mod)

	LTmodify( file_name, 'C2', [num2str(C2_mod(cycles_C2)) 'n']) ;
	
	for cycles_R0=1:1:length(R0_mod)
	
		text = sprintf('R0: %i C2: %f nF', cycles_R0,C2_mod(cycles_C2));
		waitbar((cycles_C2*(length(R0_mod))+cycles_R0)/(length(R0_mod)*length(C2_mod)),wait,text);
		
		LTmodify( file_name, 'R0', [num2str(R0_mod(cycles_R0))]) ;
		
		raw=LTautomation(file_name); 		%Run the simulation
		sim_length=length(raw.time_vect);	%Simulation time steps (The minimum time step varies)

		%Use only last 'periods' for the power caclculations
		%As time steps are variable this loop will parse the time values to isolate last periods
		i=1;
		last=raw.time_vect(sim_length);
		ini=last;
		while last-ini<=periods*T
			ini=raw.time_vect(sim_length-i);
			i=i+1;
		end
		k=sim_length-i; %First element to integrate the waveforms

		% Searchs the varaibles in the raw data.
		% I recommend doing this manually the first time to get the voltage and current references and names fine.
		% Voltages are ALWAYS lower key, Currents keep the component name
		
		t_original=raw.time_vect(k:sim_length);
		t=t_original;
		
		%Voltage Source
		Vin=raw.variable_mat(search_var(raw, 'V(vin)'),k:sim_length);
		Iin=-raw.variable_mat(search_var(raw, 'I(V1)'),k:sim_length);
		Pin=Vin.*Iin;
		
		%Load Power
		Vout=raw.variable_mat(search_var(raw, 'V(vout+)'),k:sim_length)-raw.variable_mat(search_var(raw, 'V(vout-)'),k:sim_length);
		Iout=raw.variable_mat(search_var(raw, 'I(R0)'),k:sim_length);
		Pout=Vout.*Iout;

		%Inverter Output - Link Input Power
		Ilinkin=-raw.variable_mat(search_var(raw, 'I(C1)'),k:sim_length);
		Vlinkin=raw.variable_mat(search_var(raw, 'V(vsw)'),k:sim_length);
		Plinkin=Ilinkin.*Vlinkin;
		
		%Link Output - Auxuiliary Input Power
		Vlinkout=raw.variable_mat(search_var(raw, 'V(vaux+)'),k:sim_length);
		Ilinkout=-(raw.variable_mat(search_var(raw, 'I(R2)'),k:sim_length));
		Plinkout=Ilinkout.*Vlinkout;
		
		%Auxuiliary Output - Rectifier Input Power
		Vrectin=raw.variable_mat(search_var(raw, 'V(vrect)'),k:sim_length);
		Irectin=(raw.variable_mat(search_var(raw, 'I(D1)'),k:sim_length)-raw.variable_mat(search_var(raw, 'I(D3)'),k:sim_length));
		Prectin=Irectin.*Vrectin;

		%Eliminates all NaN data that appear
		%For some reason some data appear corrupt as NaN data in the simulation
		%Maybe because the UTF codification being invalid in LTsice2Matlab function?
		NaN_cnt=0;
		reduced_sim_length=length(Pin);
		i=1;
		while(i<=reduced_sim_length-NaN_cnt)
			if isnan(Pin(i))|isnan(Pout(i))|isnan(t(i))|isnan(Prectin(i))|isnan(Plinkin(i))|isnan(Plinkout(i))
				NaN_cnt=NaN_cnt+1;
				Pin(i)=[]; Pout(i)=[]; t(i)=[]; %Eliminates the element from all vectors
				Plinkout(i)=[];Plinkin(i)=[];Prectin(i)=[];
			else
				i=i+1; %It doesnt increse if a NaN is found
			end
		end
		
		%Integrate numerically the Power of the different Stages
		Pinv(cycles_C2,cycles_R0)=trapz(t,Pin)/(periods*T);
		Poutv(cycles_C2,cycles_R0)=trapz(t,Pout)/(periods*T);
		Plinkoutv(cycles_C2,cycles_R0)=trapz(t,Plinkout)/(periods*T);
		Plinkinv(cycles_C2,cycles_R0)=trapz(t,Plinkin)/(periods*T);
		Prectinv(cycles_C2,cycles_R0)=trapz(t,Prectin)/(periods*T);
		
		%Efficiency of the different Stages
		efic_total(cycles_C2,cycles_R0)=Poutv(cycles_C2,cycles_R0)/Pinv(cycles_C2,cycles_R0);
		efic_inverter(cycles_C2,cycles_R0)=Plinkinv(cycles_C2,cycles_R0)/Pinv(cycles_C2,cycles_R0);
		efic_link(cycles_C2,cycles_R0)=Plinkoutv(cycles_C2,cycles_R0)/Plinkinv(cycles_C2,cycles_R0);
		efic_aux(cycles_C2,cycles_R0)=Prectinv(cycles_C2,cycles_R0)/Plinkoutv(cycles_C2,cycles_R0);
		efic_rect(cycles_C2,cycles_R0)=Poutv(cycles_C2,cycles_R0)/Prectinv(cycles_C2,cycles_R0);
	end
end
waitbar(1,wait,'Simulation ended');
LTmodify( file_name, 'R0', '{R0}') ; %Back to origin
LTmodify( file_name, 'C2', '{C2}') ;	

%{
linewidth=1.0;
figure();
hold on
grid on;
plot(R0_mod,efic_total,'LineWidth',linewidth);
plot(R0_mod,efic_inverter,'LineWidth',linewidth);
plot(R0_mod,efic_link,'LineWidth',linewidth);
plot(R0_mod,efic_aux,'LineWidth',linewidth);
plot(R0_mod,efic_rect,'LineWidth',linewidth);
legend('\eta total','\eta inverter','\eta link','\eta aux', '\eta rect')
title('\eta')
xlabel('R0')

figure();
grid on;
yyaxis left 
plot(R0_mod,efic_total,'LineWidth',linewidth);
xlabel('R0(\Omega)')
ylabel('\eta')
yyaxis right 
plot(R0_mod,Poutv,'LineWidth',linewidth);
xlabel('R0 (\Omega)')
ylabel('Pout (W)')
title('\eta vs Pout')
%}

delete(wait)
save(['../../data/' file_name '_full.mat'])

%Auxiliary Function to search variables in the RAW data recieved from LTSpice
function index=search_var(raw, variable_name)
	for index=1:1:length(raw.variable_name_list)
		if strfind(raw.variable_name_list{index}, variable_name)%CASE SENSITIVE!!
			return;
        end
    end
    error('Component not found');
    %@TODO: Handle strfind EXCEPTIONS
end
