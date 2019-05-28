
T=1/6.79e6;
periods=100;
addpath('../functions');
C2=0.38287;
C2_mod=linspace(0.8*C2,1.2*C2,10);

for cycles=1:1:length(C2_mod)
	
	LTmodify( 'WPT_Coupled_Inv_ZVS.asc', 'C2', [num2str(C2_mod(cycles)) 'n']) ;
	
	raw=LTautomation('WPT_Coupled_Inv_ZVS.asc');
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
	t=raw.time_vect(k:sim_length);
	Vin=raw.variable_mat(search_var(raw, 'V(vin)'),k:sim_length);
	Iin=-raw.variable_mat(search_var(raw, 'I(V1)'),k:sim_length);

	VoutP=raw.variable_mat(search_var(raw, 'V(vout+)'),k:sim_length);
	VoutN=raw.variable_mat(search_var(raw, 'V(vout-)'),k:sim_length);
	Vout=VoutP-VoutN;

	Iout=raw.variable_mat(search_var(raw, 'I(R0)'),k:sim_length);
	Pin=Vin.*Iin;
	Pout=Vout.*Iout;

	%Eliminates all NaN data that appear
	NaN_cnt=0;
	reduced_sim_length=length(Pin);
	i=1;
	while(i<=reduced_sim_length-NaN_cnt)
		if isnan(Pin(i))|isnan(Pout(i))|isnan(t(i))
			NaN_cnt=NaN_cnt+1;
			Pin(i)=[]; Pout(i)=[]; t(i)=[]; %Eliminates the element from all vectors
		else
			i=i+1; %It doesnt increse if a NaN is found
		end
	end

	figure();
	hold on;
	grid on;
	plot(t,Pin)
	plot(t,Pout)
	Pinv=trapz(t,Pin)/(periods*T);
	Poutv=trapz(t,Pout)/(periods*T);
	efic(cycles)=Poutv/Pinv;
end
figure();
plot(efic);



function index=search_var(raw, variable_name)
	for index=1:1:length(raw.variable_name_list)
		if strfind(raw.variable_name_list{index}, variable_name)
			break
		end
	end
end
