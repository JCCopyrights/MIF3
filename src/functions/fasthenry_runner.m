%% FastHenry2 Runner
% [L,R,Frequency]=fasthenry_runner(file_name,directives,show)
%
% Author: JCCopyrights Summer 2019
% Tries to execute the file file_name with Fasthery2 automations
% Extra parameters can be added via directives to the FastHenry2 execution
% If show is true, the FastHenry2 window will open to follow the execution
%% Parameters
% * @param 	*file_name*		FastHenry script to run
%
% * @param 	*directives*	String of Extra directives to run FastHenry2
%
% * @param 	*show*			Boolean Activates the FastHenry2 GUI
%
% * @retval	*L* 			Array if Inductances
%
% * @retval	*R* 			Array of Resistances
%
% * @retval	*Frequency* 	Array of Frequencies FastHenry2 Script is Evaluated
%% Code
function [L,R,Frequency]=fasthenry_runner(file_name,directives,show)
	ax=actxserver('FastHenry2.Document');
	%pwd returns the current working directory
	if show
		ax.invoke('ShowWindow');
	end
	ax.invoke('Run',['"' pwd '/' file_name '"' ' '  directives]);
	while(ax.invoke('IsRunning'))
	pause(0.1);%@TODO use same handler, this doesn`t work if the simulation is too fast
	end
	%names=ax.invoke('GetRowPortNames');
	L=cell2mat(ax.invoke('GetInductance'));
	R=cell2mat(ax.invoke('GetResistance'));
	Frequency=cell2mat(ax.invoke('GetFrequencies'));
	ax.invoke('Quit');
	ax=[];
end