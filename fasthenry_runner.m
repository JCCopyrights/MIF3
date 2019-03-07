function [L,R,Frequency]=fasthenry_runner(file_name)
	% [L,R,Frequency]=fasthenry_runner(file_name)
	ax=actxserver('FastHenry2.Document');
	%pwd returns the current working directory
	ax.invoke('Run',[pwd '/' file_name]);
	while(ax.invoke('Isrunning'))
	pause(0.1);
	end
	L=cell2mat(ax.invoke('GetInductance'));
	R=cell2mat(ax.invoke('GetResistance'));
	Frequency=cell2mat(ax.invoke('GetFrequencies'));
	ax.invoke('Quit');
	ax=[];
end