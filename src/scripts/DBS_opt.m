addpath('../functions')
N1=10; d1=0.5;
N2=5; d2=1;
range=20;
L1=zeros(range-1,76);
L2=zeros(range-1,76);
R1=zeros(range-1,76);
R2=zeros(range-1,76);
k=zeros(range-1,76);
for N1=2:1:range
	i=1;
	for d1=0:0.1:15/N1
		X = round_spiral(N1, 15, d1, 0, 500, 0, 0, 0, 0, 0, 0);
		Y = round_spiral(N2, 5, d2, 0, 500, 0, 0, -15, 0, 0, 0);
		primary=generate_coil('primary',X,5.8e4,0.2,0.2,1,1,2.0,2.0);
		secundary=generate_coil('secundary',Y,5.8e4,0.2,0.2,1,1,2.0,2.0);
		coils={primary,secundary};
		freq=500e3; 
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
		%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
		Rs=squeeze((R(1,:,:)));
		Ls=squeeze((L(1,:,:)));
		R1(N1-1,i)=Rs(1,1);
		R2(N1-1,i)=Rs(1,1);
		L1(N1-1,i)=Ls(1,1);
		L2(N1-1,i)=Ls(2,2);
		k(N1-1,i)=Ls(1,2)/sqrt(Ls(1,1)*Ls(2,2));
		i=i+1;
	end
end
Q1=2*pi*500e3*L1./R1;
Q2=2*pi*500e3*L2./R2;

