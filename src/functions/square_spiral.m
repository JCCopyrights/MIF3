%% Square Spiral
% X = square_spiral(N,A,L,d,x0,y0,z0,phix,phiy,phiz,view)
%
% Author: JCCopyrights Summer 2019
% This function generates a flat rectangular spiral - PCB Inductor
% geometry to be used as a coil. The coil will be generated with center
% in (0,0,0) in XY plane. It can be moved using the x0,..,phix... parameters
%
%% Parameters
% * @param 	*N*		Number of Turns
%
% * @param 	*A*		Width of the coil
%
% * @param 	*L*		Height of the coil
%
% * @param 	*d*		Distane bewtween turns
%
% * @param 	*x0*	Center position X
%
% * @param 	*y0*	Center position Y
%
% * @param 	*z0*	Center position Z
%
% * @param 	*phix*	Turn respect X axis 
%
% * @param 	*phiy*	Turn respect Y axis
%
% * @param 	*phiz*	Turn respect Z axis
%
% * @param 	*view*	Optional parameter, if true generates figure with geometry
%
% * @retval	*X* 	Geometry nodes	
%% Code
function X = square_spiral(N,A,L,d,x0,y0,z0,phix,phiy,phiz,view)
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
	
	if nargin>10
		if view
			plot3(X(1,:),X(2,:),X(3,:))
			grid on
			xlabel('X')
			ylabel('Y')
			zlabel('Z')
			title('Square Spiral');
		end
	end
end
%% Geometry
% 
% <<..\..\..\doc\functions\res\square.PNG>>
% 



