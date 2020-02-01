%% Generate Coil
% s=generate_coil(coil_name,X,sigma,w,h,nhinc,nwinc,rh,rw)
%
% Author: JCCopyrights Summer 2019
% Packages geometry,conductor information and discretization information into a struct
% Also calculates the length and area of the coil geometry
% the sctruct is compatible with the function fasthenry_Creator @TODO: Convert coils into a class
%% Parameters
% * @param 	*coil_name*	Coil Identifier
%
% * @param 	*X*			Coil Geometry X(1,:) X points X(2,:) Y points  X(3,:) Z points
%
% * @param 	*sigma*		Conductor Conductivity
%
% * @param 	*w*			Coil Width
%
% * @param 	*h*			Coil Height
%
% * @param 	*nhinc*		Conductor Discretization Height
%
% * @param 	*nwinc*		Conductor Discretization Width
%
% * @param 	*rh*		Discretization range
%
% * @param 	*rw*		Discretization range
%
% * @retval	*s* 		Struct Packaged Coil	
%% Code	
function s=generate_coil(coil_name,X,sigma,w,h,nhinc,nwinc,rh,rw)

	field  = 'X';
	field0 = 'coil_name';
	field1 = 'sigma';   					%Conductivity
	field2 = 'w';		field3 = 'h';  		%Conductor Width,Height
	field4 = 'nhinc';	field5 = 'nwinc';  	%Conductor Discretization
	field6 = 'rh';		field7 = 'rw'; 		%Discretization range
	%field8 = 'wx';		field9 = 'wy';		field10 = 'wz';
	field11= 'length';
	field12= 'area';
	long=0;
	for i=1:1:length(X)-1
		long=long+norm(X(:,i+1)-X(:,i));
	end
	area=w*h;
	
	s = struct(field0,coil_name,field1,sigma,field2,w,field3,h,field4,nhinc,field5,nwinc,field6,rh,field7,rw,field,X,field11,long,field12,area);
%% Discretization 	
% 
% <<..\..\..\doc\functions\res\discretizacion.PNG>>
% 
%% AWG Standard sizes
%{	
			Conductor					  |		Ampacity[A]
-----------------------------------------------------------------
AWG		Diam[mm]	Area[mm2]	mOhm/m    |  60 °C   75 °C   90 °C
-----------------------------------------------------------------
1		7.348		42.4		0.4066		110		130		145		 
2		6.544		33.6		0.5127	    95		115		130	
3		5.827		26.7		0.6465	    85		100		115	
4		5.189		21.2		0.8152	    70		85		95	
5		4.621		16.8		1.028	    -		-		-
6		4.115		13.3		1.296	    55		65		75	
7		3.665		10.5		1.634	    -		-		-
8		3.264		8.37		2.061	    40		50		55	
9		2.906		6.63		2.599	    -		-		-
10		2.588		5.26		3.277	    30		35		40	
11		2.305		4.17		4.132	    -		-		-
12		2.053		3.31		5.211	    20		25		30	
13		1.828		2.62		6.571	    -		-		-
14		1.628		2.08		8.286	    15		20		25	
15		1.450		1.65		10.45	    -		-		-
16		1.291		1.31		13.17	    -		18		-
17		1.150		1.04		16.61	    -		-		-
18		1.024		0.823		20.95	    10		14		16	
19		0.912		0.653		26.42	    -		-		-	
20		0.812		0.518		33.31	    5		11		-	
21		0.723		0.410		42.00	    -		-		-	
22		0.644		0.326		52.96	    5		7		-	
23		0.573		0.258		66.79	    -		-		-	
24		0.511		0.205		84.22	    2.1		3.5		-	
25		0.455		0.162		106.2	    -		-		-	
26		0.405		0.129		133.9	    1.3		2.2		-	
27		0.361		0.102		168.9	    -		-		-	
28		0.321		0.0810		212.9	    0.83	1.4		-	
29		0.286		0.0642		268.5	    -		-		-	
30		0.255		0.0509		338.6	    0.52	0.86	-	
31		0.227		0.0404		426.9	    -		-		-	
32		0.202		0.0320		538.3	    0.32	0.53	-	
33		0.180		0.0254		678.8	    -		-		-	
34		0.160		0.0201		856.0	    0.18	0.3		-	
35		0.143		0.0160		1079	    -		-		-	
36		0.127		0.0127		1361	    -		-		-	
37		0.113		0.0100		1716	    -		-		-	
38		0.101		0.00797		2164	    -		-		-	
39		0.0897		0.00632		2729	    -		-		-	
40		0.0799		0.00501		3441	    -		-		-	
%}








































