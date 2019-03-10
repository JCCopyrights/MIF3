%% Helicoidal Spiral
% X = helix_spiral(N,r0,h,phi0,RES,x0,y0,z0,phix,phiy,phiz,view)
%
% This function generates a Helicoidal circular spiral
% geometry to be used as a coil. The coil will be generated with center
% in (0,0,0) in XY plane. It can be moved using the x0,..,phix... parameters
%
%% Parameters
% * @param 	*N*		Number of Turns
%
% * @param 	*r0*	External radius of the coil
%
% * @param 	*h*		Height bewtween turns
%
% * @param 	*phi0*	Angle at which the turns start
%
% * @param 	*RES*	Number of  nodes of the Geometry (Discretization)
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
function X = helix_spiral(N,r0,h,phi0,RES,x0,y0,z0,phix,phiy,phiz,view)
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
	X(3,:)= h/(2*pi)*phi;
	%The max height of the Helix is N*h
	for i=1:size(t,2)
		X(:,i)=transpose(Rx*[X(1,i);X(2,i);X(3,i)]);		
		X(:,i)=transpose(Ry*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=transpose(Rz*[X(1,i);X(2,i);X(3,i)]);
		X(:,i)=X(:,i)+[x0;y0;z0];
	end
	if nargin>11
		if view
			plot3(X(1,:),X(2,:),X(3,:))
			grid on
			xlabel('X')
			ylabel('Y')
			zlabel('Z')
			title('Helix Spiral');
		end
	end
end
%% Geometry
% 
% <<..\..\doc\functions\res\hex.PNG>>
% 





