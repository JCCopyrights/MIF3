%% Documentation Script
% Takes EVERYTHING in the functions directory and tries to document it =>PUBLISHER.

directory=dir('../functions');
f=waitbar(0,'Initialization');
options = struct('format','pdf','outputDir','..\..\doc\functions', 'evalCode', false);
% @TODO: Document only files that have changed.
for i=3:1:size(directory,1)
	text = sprintf('Document: %s', directory(i).name);
	waitbar((i-2)/size(directory,1),f,text);
	publish([directory(i).folder '\' directory(i).name], options );
end
waitbar(1,f,'Simulation ended');
delete(f)