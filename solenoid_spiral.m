function X = solenoid_spiral(N,r0,h,phir,phi0,RES,x0,y0,z0,phix,phiy,phiz)
	Rx=[1,0,0;0,cos(phix),-sin(phix);0,sin(phix),cos(phix)];
	Ry=[cos(phiy),0,sin(phiy);0,1,0;-sin(phiy),0,cos(phiy)];
	Rz=[cos(phiz),-sin(phiz),0;sin(phiz),cos(phiz),0;0,0,1];
	omega =.010;
	t = linspace(0,2*pi*N/omega,RES);
	X=ones(3,size(t,2));
	phi = omega*t+phi0;
	r = r0;
	X(1,:) = r .* cos(phi);
	X(2,:) = r .* sin(phi);
	X(3,1)=0;
	counter=phir;
	counter2=(2*pi+phi0);
	phi_RES=omega*2*pi*N/(omega*(RES-1));
	for i=2:size(t,2)
		if phi(i)>=counter
			%Starts Increasing for next Turn.
			X(3,i)=X(3,i-1)+h/((2*pi+phi0-phir)/phi_RES);
			if phi(i)>=counter2
				%Starts new Turn.
				counter=counter+2*pi;
				counter2=counter2+2*pi;
			end
		else
			X(3,i)=X(3,i-1);
		end
	end
	%The max height of the Helix is N*h
	for i=1:size(t,2)
		X(:,i)=transpose(Rx*[X(1,i);X(2,i);X(3,i)]);		
		X(:,i)=transpose(Ry*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=transpose(Rz*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=X(:,i)+[x0;y0;z0];
	end
	plot3(X(1,:),X(2,:),X(3,:));
	grid on
	xlabel('X')
	ylabel('Y')
	zlabel('Z')
	hold on;
end






