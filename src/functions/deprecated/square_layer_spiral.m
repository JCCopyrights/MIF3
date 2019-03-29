%% Square Spiral Layer
% X = square_layer_spiral(N,A,L,d,layers,h,x0,y0,z0,phix,phiy,phiz,view)
%
% This function generates a flat rectangular multilayer spiral - PCB Inductor
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
% * @param 	*layers*Number of  layers of the Geometry 
%
% * @param 	*h*		Distance between layers of the Coil
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
% * @retval	*X* 		Geometry nodes
%% Code	
function X = square_layer_spiral(N,A,L,d,layers,h,x0,y0,z0,phix,phiy,phiz,view)
	Rx=[1,0,0;0,cos(phix),-sin(phix);0,sin(phix),cos(phix)];
	Ry=[cos(phiy),0,sin(phiy);0,1,0;-sin(phiy),0,cos(phiy)];
	Rz=[cos(phiz),-sin(phiz),0;sin(phiz),cos(phiz),0;0,0,1];
	X=[];
	X=[X,square_spiral(N,A,L,d,0,0,0,0,0,0,false)];
	for i=2:1:layers
		if  mod(i,2)==1 %Assures the correct direction of the turns
			Xaux=X(:,size(X,2))+[0;0;-h];
			X=[X,Xaux,square_spiral(N,A,L,d,0,0,-h*(i-1),0,0,0,false)];
		else  
			Xaux=fliplr(square_spiral(N,A,L,d,0,0,-h*(i-1),pi,0,0,false));
			Xaux(:,1)=X(:,size(X,2))+[0;0;-h];
			X=[X,Xaux,Xaux(:,size(Xaux,2))+[-d;0;0],Xaux(:,size(Xaux,2))+[-d;L;0] ];
		end
	end
	for i=1:size(X,2)
		X(:,i)=transpose(Rx*[X(1,i);X(2,i);X(3,i)]);		
		X(:,i)=transpose(Ry*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=transpose(Rz*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=X(:,i)+[x0;y0;z0];
	end
	if nargin>12
		if view
			plot3(X(1,:),X(2,:),X(3,:))
			grid on
			xlabel('X')
			ylabel('Y')
			zlabel('Z')
			title('Square Layer Spiral');
		end
	end
end
%% Geometry
% 
% <<..\..\doc\functions\res\square_layer.PNG>>
% 





