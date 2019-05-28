%%INterface with LTSPice .asc files
% component_find = LTmodify( file_name, component, value ) )
%
% This function will search for a specific component in a .asc simulation file and 
% modify its value
%% Parameters
% * @param 	*file_name*		Name of .asc file to be executed. It must be in the /sim folder of the project
%
% * @param 	*component*		Name of the component to be modified
%
% * @retval	*component_find* True if the component is found in the .asc
%
%% Code
function component_find = LTmodify( file_name, component, value ) 
	repo_path='C:\Users\johnc\Dropbox\TFM\source\MIF3\';
	sim_path=[repo_path 'sim\'];
	S = fileread([sim_path file_name]);
	C = strsplit(S, '\n');
	i=1;
	component_find=false;
	spice_component=sprintf('SYMATTR InstName %s', component);
	while isempty(strfind(C{i},spice_component))
		i=i+1;
		component_find=true;
	end
	if component_find
		%disp('Component Found')
		spice_value=sprintf('SYMATTR Value  %s', value);
		C{i+1}=spice_value;
		fid = fopen([sim_path file_name], 'w');
		for i=1:1:length(C)
			fprintf(fid, '%s\n', C{i});
		end
		%disp('Component Value replaced')
		fclose(fid);
	else
		disp('Component not Found')
	end
