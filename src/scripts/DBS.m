addpath('../functions')

X = round_spiral(15, 15, 1, 0, 1500, 0, 0, 0, 0, 0, 0);
%Y = round_spiral(5, 15, 0.5, 0, 1000, 0, 0, 15, 0, 0, 0);
%X = square_spiral(5,10,10,0.2,0,0,0,0,0,0);
Y = round_spiral(20, 5, 0, 0, 1500, 0, 0, -15, 0, 0, 0);

primary=generate_coil('primary',X,5.8e4,0.2,0.2,2,2,2.0,2.0);
secundary=generate_coil('secundary',Y,5.8e4,0.2,0.2,2,2,2.0,2.0);

coils={primary,secundary};
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

freq=300e3; 
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
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
