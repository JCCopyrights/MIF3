%% LTSpice 2 Matlab automation
% This script calculate the power and efficiency of different stages
% Modifies the R0 laod to check power and efficiency.
T=1/6.79e6;
periods=100;
addpath('../functions');
R0=8;
R0_mod=R0; %linspace(1,100,100);
file_name='WPT_inv_rect_aux.asc';
for cycles=1:1:1
	raw=LTautomation(file_name);
	sim_length=length(raw.time_vect);

	%Use only last periods for the calculus
	last=raw.time_vect(sim_length);
	ini=last;
	i=1;
	while last-ini<=periods*T
		ini=raw.time_vect(sim_length-i);
		i=i+1;
	end
	k=sim_length-i;

	%Searchs the varaibles in the raw data.
	%I recommend doing this manually the first time to get the voltage and current references and names fine.
	% Voltages are ALWAYS lower key, Currents keep the component name
	t_original=raw.time_vect(k:sim_length);
    t=t_original;
	Vin=raw.variable_mat(search_var(raw, 'V(vin)'),k:sim_length);
	Iin=-raw.variable_mat(search_var(raw, 'I(V1)'),k:sim_length);

	VoutP=raw.variable_mat(search_var(raw, 'V(vout+)'),k:sim_length);
	VoutN=raw.variable_mat(search_var(raw, 'V(vout-)'),k:sim_length);
	Vout=VoutP-VoutN;

	Iout=raw.variable_mat(search_var(raw, 'I(R0)'),k:sim_length);
	Pin=Vin.*Iin;
	Pout=Vout.*Iout;

	Ilinkin=-raw.variable_mat(search_var(raw, 'I(C1)'),k:sim_length);
	Vlinkin=raw.variable_mat(search_var(raw, 'V(vsw)'),k:sim_length);
	Plinkin=Ilinkin.*Vlinkin;
	
	Vlinkout=raw.variable_mat(search_var(raw, 'V(vaux+)'),k:sim_length);
	Ilinkout=-(raw.variable_mat(search_var(raw, 'I(R2)'),k:sim_length)+raw.variable_mat(search_var(raw, 'I(Cp2)'),k:sim_length));
	Plinkout=Ilinkout.*Vlinkout;
	
	Vrectin=raw.variable_mat(search_var(raw, 'V(vrect)'),k:sim_length);
	Irectin=(raw.variable_mat(search_var(raw, 'I(D1)'),k:sim_length)-raw.variable_mat(search_var(raw, 'I(D3)'),k:sim_length));
	Prectin=Irectin.*Vrectin;

	%Eliminates all NaN data that appear
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

	%figure();
	%hold on;
	%grid on;
	%plot(t,Pin)
	%plot(t,Pout)
	Pinv(cycles)=trapz(t,Pin)/(periods*T);
	Poutv(cycles)=trapz(t,Pout)/(periods*T);
	Plinkoutv(cycles)=trapz(t,Plinkout)/(periods*T);
	Plinkinv(cycles)=trapz(t,Plinkin)/(periods*T);
	Prectinv(cycles)=trapz(t,Prectin)/(periods*T);
	efic_total(cycles)=Poutv(cycles)/Pinv(cycles);
	efic_inverter(cycles)=Plinkinv(cycles)/Pinv(cycles);
	efic_link(cycles)=Plinkoutv(cycles)/Plinkinv(cycles);
	efic_aux(cycles)=Prectinv(cycles)/Plinkoutv(cycles);
	efic_rect(cycles)=Poutv(cycles)/Prectinv(cycles);
end

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
delete(wait)
save('../../data/LTsim.mat')

function index=search_var(raw, variable_name)
	for index=1:1:length(raw.variable_name_list)
		if strfind(raw.variable_name_list{index}, variable_name)%CASE SENSITIVE!!
			return;
        end
    end
    error('Component not found');
    %@TODO: Handle strfind exCEPTIONS
end
