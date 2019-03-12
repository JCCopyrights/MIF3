addpath('../functions')

figure();
hold on;
grid on;

X = round_spiral(15, 15, 1, 0, 1500, 0, 0, 0, 0, 0, 0, true);
Y = round_spiral(20, 5, 0.1, 0, 1500, 0, 0, -15, 0, 0, 0, true);

primary=generate_coil('primary',X,5.8e4,0.2,0.2,2,2,2.0,2.0);
secundary=generate_coil('secundary',Y,5.8e4,0.2,0.2,2,2,2.0,2.0);
coils={primary,secundary};

title('WPT Topology');
legend({primary.coil_name,secundary.coil_name},'Location','east')
legend('boxoff')

freq=500e3; 
directives='-o 2 -r 2';
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),directives,true);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

disp('Inductances and Resistances')
RC=squeeze((R(1,:,:)));
LC=squeeze((L(1,:,:)));
disp(RC+j*LC)

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
