figure();
X = round_spiral(10, 5, 0.1, 0, 1000, 0, 0, 0, 0, 0, 0);
Y = round_spiral(10, 15, 0.5, 0, 1000, 0, 0, 15, 0, 0, 0);
Z = round_spiral(10, 15, 0.5, 0, 1000, 0, 0, -15, 0, 0, 0);
A = round_spiral(10, 15, 0.5, 0, 1000, 0, 16, 0, pi/2, 0, 0);
coils={X,Y,Z,A};
title('WPT Topology');
legend({'coil1','coil2','coil3','coil4'},'Location','east')
legend('boxoff')
freq=500e3; 
w=0.05; th=0.05;%Width and Thick of the conductors
%Notice that ALL the coils will be made with this conductors @TODO: Different conductors for different coils
nhinc=2; nwinc=2;
[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq,w,th,nhinc,nwinc));
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