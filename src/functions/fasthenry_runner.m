function [L,R,Frequency]=fasthenry_runner(file_name,directives,show)
	% [L,R,Frequency]=fasthenry_runner(file_name,directives,show)
	% Tries to execute the file file_name with fasthery2 
	% Extra parameters can be added via directives to the FastHenry2 execution
	% If show is true, the FastHenry2 window will open to follow the execution

	ax=actxserver('FastHenry2.Document');
	%pwd returns the current working directory
	if show
		ax.invoke('ShowWindow');
	end
	ax.invoke('Run',[pwd '/' file_name ' '  directives]);
	while(ax.invoke('Isrunning'))
	pause(0.1);
	end
	%names=ax.invoke('GetRowPortNames');
	L=cell2mat(ax.invoke('GetInductance'));
	R=cell2mat(ax.invoke('GetResistance'));
	Frequency=cell2mat(ax.invoke('GetFrequencies'));
	ax.invoke('Quit');
	ax=[];
end