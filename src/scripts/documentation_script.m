%% Documentation Script
% Takes EVERYTHING in the functions directory and tries to document it =>PUBLISHER.

directory=dir('../functions');
for i=3:1:size(directory,1)
	options = struct('format','pdf','outputDir','..\..\doc\functions', 'evalCode', false);
	publish([directory(i).folder '\' directory(i).name], options );
end