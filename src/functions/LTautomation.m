%%Automation for LTSPice
% raw_data=LTautomation(file_name)
%
% Author: JCCopyrights Summer 2019
% This function will execute a LTSpice XVII run it and return a struct containing
% all signals in the simulation. Only executes files in the sim folder.
%% Parameters
% * @param 	*file_name*		Name of .asc file in the sim folder to be executed
%
% * @retval	*raw_data*		Returns the struct with all the signals
%
%% Code
function raw_data=LTautomation(file_name)
	addpath('../../utilities');
	repo_path='C:\Users\johnc\Dropbox\TFM\source\MIF3\';
	ltspice_path='C:\Program Files\LTC\LTspiceXVII\XVIIx64.exe';
	sim_path=[repo_path 'sim\'];
	cmd =['"' ltspice_path '"' ' -Run -b ' sim_path file_name];
	[trash, trash]=system(cmd); %Avoid seeing the commands
	len=length(file_name);
	file_name(len-3:len)='.raw'; %Searches the .raw file generated
	raw_data=LTspice2Matlab([sim_path file_name]);%Imports all the data
