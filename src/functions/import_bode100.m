%% Import BODE100
% data=import_bode100(filename)
%
% Author: JCCopyrights Summer 2019
% Project: CRANE: Medical WPT for Deep Brain Stimulation Implants
% Imports the data from a csv file generated from Bode Analyzer Suite
% Generates a struct that contains the data of all the traces.
%% Parameters
% * @param 	*filename*  Filename/Directory of csv to be imported.
%
% * @retval	*data* 		Output Struct.
%
% * @TODO: Automate the trace detection of the .csv files (Read title after : and interpret the Strings)
%% Code	
function data=import_bode100(filename)
	raw_bode = csvread(filename,1,0); %Ignore title
	%Could check for what taces are included in csv file but fuck you.
	data.name=filename;
	data.raw.f=raw_bode (:,1);
	data.raw.Z=raw_bode (:,2);
	data.raw.theta=raw_bode (:,3);
	data.raw.Ls=raw_bode (:,4);
	data.raw.Rs=raw_bode (:,5);
	data.raw.Q=raw_bode (:,6);
	%raw_data=readtable(filename); Using tables this will pack more info
		
%  		| - Name: Original csv file
%  		|
%  		|		|-f: frequency range
%  data	|		|-Z: Impedance in ohm
%  		| - raw:|-theta: Impedance phase in degrees
%  		|		|-Ls: Series Inductance
%  		|		|-Rs: Real Impedance
%  		|		|-Q: Quality factor