%% FastCap2 Creator
% file_name=fastcap2_creator(in_file_name,out_file_name,permitivity, command)
%
% This function will take a FastHenry2.inp compatible input and generate .lst and .qui files for FastCap2
% Beware that file_name must be a string 'This_is_a_File_Name'
%% Parameters
% * @param 	*in_file_name*		Name of .ino fie to be converter
%
% * @param 	*out_file_name*		Name of file to be created
%
% * @param 	*permitivity*		Medium permitivity
%
% * @param  *command*			Extra commands to the program
%
% * @retval	*file_name*			Returns the name of the created file
%
%% Code
function file_name=fastcap2_creator(in_file_name,out_file_name,permitivity, command)
	file_name=['list_' out_file_name '.lst'];
	bash = sprintf('convertHenry -n%s -llist_%s -g%s -c%f %s',in_file_name,out_file_name,out_file_name,permitivity,command);
	[ status, cmdout ]=system([bash]);