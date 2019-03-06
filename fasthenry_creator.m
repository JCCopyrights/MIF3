function file_name=fasthenry_creator(file_name,coils)
	%This function will take coils as input and generate a FastHenry2 compatible output
	%Beware that file_name must be a string 'This_is_a_File_Name'
	%Coils must be a cell array of an arbitrary number of coils 
	%Coils elements must be defined as Matrix (3 x N), beign (1 :) X Coordenates, (2 :) Y Coordenates, (3 :) Z Coordenates
	file_name=[file_name '.inp'];
	fast_henry=fopen(file_name,'w'); 
	fprintf(fast_henry,'* FastHenry2 File Automatically Generated.... JCCopyrights 2019\n');
	fprintf(fast_henry,'.Units MM\n');
	w=0.1; th=0.1;
	fprintf(fast_henry,'.Default z=0 sigma=5.8e4 w=%g h=%g\n',w,th);
	index=1;%Will assure no overlaping between Nodes for different coils
	%Generates Nodes and Segments for every Coil Introduced
	for j=1:1:size(coils,2)
		fprintf(fast_henry,'\n*Coil %d Nodes:\n', j);
		X=cell2mat(coils(j));
		for i=index:1:index+size(X,2)-1
			fprintf(fast_henry,'N%d x=%g y=%g z=%g\n',i,X(1,i-index+1),X(2,i-index+1),X(3,i-index+1));
		end
		fprintf(fast_henry,'\n*Coil %d Segments:\n', j);
		for i=index:1:index+size(X,2)-2
			fprintf(fast_henry,'E%d N%d N%d\n',i,i,i+1);    
		end
		fprintf(fast_henry,'\n*Coil %d Electric Port:\n', j);
		fprintf(fast_henry,'.external N%d N%d',index,index+size(X,2)-1); 
		fprintf(fast_henry,'\n');
		index=index+size(X,2);
	end
	fprintf(fast_henry,'.freq fmin=508500 fmax=508500 ndec=1');
	fprintf(fast_henry,'\n');
	fprintf(fast_henry,'.end');
	fclose(fast_henry)
end