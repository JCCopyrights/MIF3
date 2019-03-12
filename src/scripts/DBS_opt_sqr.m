addpath('../functions')
N1=10; d1=0.5;
N2=2; d2=1;
range=20;
L1_sq=zeros(range-1,76);
L2_sq=zeros(range-1,76);
R1_sq=zeros(range-1,76);
R2_sq=zeros(range-1,76);
k_sq=zeros(range-1,76);
for N1=2:1:range
	i=1;
	for d1=0.001:0.1:15/N1
		X = square_spiral(N1,30,30,d1,0,0,0,0,0,0);
		Y = square_spiral(N2,10,10,d2,0, 0, -15, 0, 0, 0);
		primary=generate_coil('primary',X,5.8e4,0.2,0.2,1,1,2.0,2.0);
		secundary=generate_coil('secundary',Y,5.8e4,0.2,0.2,1,1,2.0,2.0);
		coils={primary,secundary};
		freq=500e3; 
		[L,R,Frequency]=fasthenry_runner(fasthenry_creator('SurpriseMotherFucker',coils,freq),'',true);
		%To acces like a semi-functional human being to the matrix => squeeze((L(i,:,:))) squeeze((R(i,:,:)))
		Rs=squeeze((R(1,:,:)));
		Ls=squeeze((L(1,:,:)));
		R1_sq(N1-1,i)=Rs(1,1);
		R2_sq(N1-1,i)=Rs(1,1);
		L1_sq(N1-1,i)=Ls(1,1);
		L2_sq(N1-1,i)=Ls(2,2);
		k_sq(N1-1,i)=Ls(1,2)/sqrt(Ls(1,1)*Ls(2,2));
		i=i+1;
	end
end
Q1_sq=2*pi*500e3*L1_sq./R1_sq;
Q2_sq=2*pi*500e3*L2_sq./R2_sq;

