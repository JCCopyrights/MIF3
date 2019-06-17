function [Rs, Ls, fres]=real_coil(L,R,C,f)
	w=2*pi*f;
	Zre=R./(w.^2.*R.^2*C^2+(1-L*C*w.^2).^2);
	Zim=(w.*L.*(1-w.^2.*L.*C-(C.*R.^2)./L))./(w.^2.*R.^2.*C^2+(1-L.*C.*w.^2).^2);
	Z=sqrt(Zre.^2+Zim.^2);
	Rs=Zre;
	Ls=Zim/w;
	fres=1/(2*pi*sqrt(L*C));