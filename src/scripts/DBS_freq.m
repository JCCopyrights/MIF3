addpath('../functions')
N1=15; d1=0.8;
N2=5; d2=1;
range=20;
L1=zeros(1,100);
L2=zeros(1,100);
k=zeros(1,100); 
i=1;
for freq=10e3:1e4:1e6
	X = round_spiral(N1, 15, d1, 0, 500, 0, 0, 0, 0, 0, 0);
	Y = round_spiral(N2, 5, d2, 0, 500, 0, 0, -15, 0, 0, 0);
	primary=generate_coil('primary',X,5.8e4,0.2,0.2,1,1,2.0,2.0);
	secundary=generate_coil('secundary',Y,5.8e4,0.2,0.2,1,1,2.0,2.0);
	coils={primary,secundary};
	[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
	%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
	R=squeeze((R(1,:,:)));
	L=squeeze((L(1,:,:)));
	L1(i)=L(1,1);
	L2(i)=L(2,2);
	k(i)=L(1,2)/sqrt(L(1,1)*L(2,2));
	i=i+1;
end


