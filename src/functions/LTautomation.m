%%Automation for LTSPice
% raw_data=LTautomation(file_name)
%
% This function will execute a LTSpice XVII run it and return a struct containing
% all signals in the simulation
%% Parameters
% * @param 	*file_name*		Name of .asc file to be executed
%
% * @retval	*raw_data*		Returns the struct with all the signals
%
%% Code
function raw_data=LTautomation(file_name)
	addpath('../../utilities');
	repo_path='C:\Users\johnc\Dropbox\TFM\source\FastHenry2_Matlab\';
	sim_path=[repo_path 'sim\'];
	batch_path=[repo_path 'utilities\']; %Because fucking space in Program Files
	cmd =[batch_path 'spice.bat' ' '  sim_path file_name];
	system(cmd);
	len=length(file_name);
	file_name(len-3:len)='.raw';
	raw_data=LTspice2Matlab([sim_path file_name]);
