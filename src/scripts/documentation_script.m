%% Documentation Script
% Takes EVERYTHING in the functions directory that is not a 
% directory and tries to document it =>PUBLISHER.
% https://es.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html

directory=dir('../functions');
f=waitbar(0,'Initialization');
options = struct('format','pdf','outputDir','..\..\doc\functions', 'evalCode', false);
% @TODO: Document only files that have changed.
for i=1:1:size(directory,1)
	text = sprintf('Document: %s', directory(i).name);
	waitbar((i-2)/size(directory,1),f,text);
	if ~directory(i).isdir && directory(i).name(length(directory(i).name))=='m'
		publish([directory(i).folder '\' directory(i).name], options );
	end
end
waitbar(1,f,'Documentation ended');
delete(f)