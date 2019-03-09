function X = square_spiral(N,A,L,d,x0,y0,z0,phix,phiy,phiz)
	% X = square_spiral(N,A,L,d,x0,y0,z0,phix,phiy,phiz)
	% Creates a square spiral - PCB Inductor
	Rx=[1,0,0;0,cos(phix),-sin(phix);0,sin(phix),cos(phix)];
	Ry=[cos(phiy),0,sin(phiy);0,1,0;-sin(phiy),0,cos(phiy)];
	Rz=[cos(phiz),-sin(phiz),0;sin(phiz),cos(phiz),0;0,0,1];
	xc=-A/2;
	yc=+L/2;
	for i=1:N
		X(1,(5*i-4))=xc+(i-1)*d;
		X(2,(5*i-4))=yc-(i-1)*d;
		X(3,(5*i-4))=0;
		X(1,(5*i-3))=xc+A-(i-1)*d;
		X(2,(5*i-3))=yc-(i-1)*d;
		X(3,(5*i-3))=0;
		X(1,(5*i-2))=xc+A-(i-1)*d;
		X(2,(5*i-2))=yc-L+(i-1)*d;
		X(3,(5*i-2))=0;
		X(1,(5*i-1))=xc+(i-1)*d;
		X(2,(5*i-1))=yc-L+(i-1)*d;
		X(3,(5*i-1))=0;
		X(1,(5*i)  )=xc+(i-1)*d;
		X(2,(5*i)  )=yc-i*d;
		X(3,(5*i))=0;
	end
	for i=1:size(X,2)
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




