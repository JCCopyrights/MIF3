%% FastHenry2 Creator
% file_name=fasthenry_creator(file_name,coils,freq)
%
% This function will take coils as input and generate a FastHenry2 compatible output
% Beware that file_name must be a string 'This_is_a_File_Name'
% Coils must be a cell array of an arbitrary number of coils units in meters [m]
%% Parameters
% * @param 	*file_name*	Name of file to be created
%
% * @param 	*coils*		Cell array of compatible structs -> see generate_coil
%
% * @param 	*freq*		Frequencies to Evaluate the coils
%
% * @retval	*file_name*	Original file_name with .inp extension
%% Code
%Esto funciona pero no junta las esquinas bien ni los saltos en Z
function file_name=capcap(file_name,coils)
	file_name=[file_name '.qui'];
	fast_cap=fopen(file_name,'w'); 
	fprintf(fast_cap,'0 FastCap2 File Automatically Generated.... JCCopyrights 2019\n');
	index=1;%Will assure no overlaping between Nodes for different coils
	%Generates Nodes and Segments for every Coil Introduced
	for j=1:1:size(coils,2)
		%Nodes ONLY depend of geometry
		fprintf(fast_cap,'\n*Coil %d Nodes:\n', j);
		coil=cell2mat(coils(j));
		X=coil.X; %coil geometry
		w=coil.w;
		h=coil.h;
		for i=index:1:index+size(X,2)-1-1-1
			fprintf(fast_cap,'\n*New Node\n');
			x0=[X(1,i-index+1),X(2,i-index+1),X(3,i-index+1)];
			x1=[X(1,i-index+2),X(2,i-index+2),X(3,i-index+2)];
			v=x1-x0;
			v=v./norm(v);
			x2=[X(1,i-index+3),X(2,i-index+3),X(3,i-index+3)];
			v2=x2-x1;
			v2=v2./norm(v2);
			if abs(dot(v,v2))<0.1 %Because fuck resolution PERPENDICULAR
				x1=x1-v*w/2;
				X(:,i-index+2)=x2-v2*w/2;
			end
			l=cross(v,[0,0,-1]);
			l=l./norm(l);
			%Numbered Clockwise
			q00=x0-w/2*l+[0,0,h/2]; 
			q01=x0+w/2*l+[0,0,h/2];  
			q02=x0+w/2*l-[0,0,h/2]; 
			q03=x0-w/2*l-[0,0,h/2]; 
			q10=x1-w/2*l+[0,0,h/2]; 
			q11=x1+w/2*l+[0,0,h/2];  
			q12=x1+w/2*l-[0,0,h/2]; 
			q13=x1-w/2*l-[0,0,h/2]; 	
			%FRONT
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q00(1),q00(2),q00(3),q01(1),q01(2),q01(3),q02(1),q02(2),q02(3),q03(1),q03(2),q03(3));
			%TOP
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q00(1),q00(2),q00(3),q10(1),q10(2),q10(3),q11(1),q11(2),q11(3),q01(1),q01(2),q01(3));
			%BOTTOM
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q02(1),q02(2),q02(3),q12(1),q12(2),q12(3),q13(1),q13(2),q13(3),q03(1),q03(2),q03(3));
			%RIGHT
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q01(1),q01(2),q01(3),q11(1),q11(2),q11(3),q12(1),q12(2),q12(3),q02(1),q02(2),q02(3));
			%LEFT
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q00(1),q00(2),q00(3),q10(1),q10(2),q10(3),q13(1),q13(2),q13(3),q03(1),q03(2),q03(3));
			%BACK
			fprintf(fast_cap,'Q %d %g %g %g %g %g %g %g %g %g %g %g %g\n',j,q10(1),q10(2),q10(3),q11(1),q11(2),q11(3),q12(1),q12(2),q12(3),q13(1),q13(2),q13(3));
			
		end
		fprintf(fast_cap,'\n*Coil %d "%s" Electric Port:\n', j,coil.coil_name);
		fprintf(fast_cap,'N %d %s' ,j,coil.coil_name); 
		fprintf(fast_cap,'\n');
		index=index+size(X,2);
	end
	%Notice that only works for ONE frequency
	fprintf(fast_cap,'\n');
	fclose(fast_cap);
end