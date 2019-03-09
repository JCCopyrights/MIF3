addpath('../functions')
X = round_spiral(10, 5, 0.1, 0, 1000, 0, 0, 0, 0, 0, 0);
Y = round_spiral(10, 15, 0.5, 0, 1000, 0, 0, 15, 0, 0, 0);
Z = round_spiral(10, 15, 0.5, 0, 1000, 0, 0, -15, 0, 0, 0);
A = round_spiral(10, 15, 0.5, 0, 1000, 0, 16, 0, pi/2, 0, 0);

coil1=generate_coil('coil1',X,5.8e4,0.2,0.2,2,2,2.0,2.0);
coil2=generate_coil('coil2',Y,5.8e4,0.2,0.2,2,2,2.0,2.0);
coil3=generate_coil('coil3',Z,5.8e4,0.2,0.2,2,2,2.0,2.0);
coil4=generate_coil('coil4',A,5.8e4,0.2,0.2,2,2,2.0,2.0);

coils={coil1,coil2,coil3,coil4};
figure();
hold on;
plot3(X(1,:),X(2,:),X(3,:));
plot3(Y(1,:),Y(2,:),Y(3,:));
plot3(Z(1,:),Z(2,:),Z(3,:));
plot3(A(1,:),A(2,:),A(3,:));
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('WPT Topology');
legend({coil1.coil_name,coil2.coil_name,coil3.coil_name,coil4.coil_name},'Location','east')
legend('boxoff')
freq=500e3; 
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',false);
%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))

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