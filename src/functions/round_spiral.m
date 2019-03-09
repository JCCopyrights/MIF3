function X = round_spiral(N,r0,d,phi0,RES,x0,y0,z0,phix,phiy,phiz)
	% X = round_spiral(N,r0,d,phi0,RES,x0,y0,z0,phix,phiy,phiz)
	% Creates a round spiral - PCB Flat Inductors
	Rx=[1,0,0;0,cos(phix),-sin(phix);0,sin(phix),cos(phix)];
	Ry=[cos(phiy),0,sin(phiy);0,1,0;-sin(phiy),0,cos(phiy)];
	Rz=[cos(phiz),-sin(phiz),0;sin(phiz),cos(phiz),0;0,0,1];
	omega =.010;
	u = d/(2*pi);
	t = linspace(0,2*pi*N/omega,RES);
	X=ones(3,size(t,2));
	phi = omega*t+phi0;
	r = r0 - u * phi ;
	X(1,:) = r .* cos(phi);
	X(2,:) = r .* sin(phi);
	X(3,:)= zeros(1,size(t,2));
	for i=1:size(t,2)
		X(:,i)=transpose(Rx*[X(1,i);X(2,i);X(3,i)]);		
		X(:,i)=transpose(Ry*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=transpose(Rz*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=X(:,i)+[x0;y0;z0];
	end
	%plot3(X(1,:),X(2,:),X(3,:))
	%grid on
	%xlabel('X')
	%ylabel('Y')
	%zlabel('Z')
	%hold on;
end






