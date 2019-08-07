# MIF3
Matlab Interface For Fast Field Solvers

The added functions for the interface include:
## Functions

### Geometries:
	* Solenoid Spiral:		X = solenoid_spiral(N,r0,h,phir,phi0,RES,x0,y0,z0,phix,phiy,phiz,view)
		* Spring with flat turns
	* Round Spiral 			X = round_spiral(N,r0,d,phi0,RES,x0,y0,z0,phix,phiy,phiz,view)
		* Single layer rounded spiral
	* Rectangular Spiral		X = square_spiral(N,A,L,d,x0,y0,z0,phix,phiy,phiz,view)
		* Single layer rectangular spiral
	* Rectangular Planar Inductor 	X = rectangular_planar_inductor(N,A,L,A0,L0,d,h,x0,y0,z0,phix,phiy,phiz,view)
		* Multilayer rectangular spiral
	* Helix Spiral			X = helix_spiral(N,r0,h,phi0,RES,x0,y0,z0,phix,phiy,phiz,view)
		* Helicoidal spring
	* Circular Planar Inductor	X = circular_planar_inductor(N,r0,ri,d,phi0,RES,h,x0,y0,z0,phix,phiy,phiz,view)
		* Multilayer circular spiral

### FastHenryv2 Interface:
	* Generate Coil:		s=generate_coil(coil_name,X,sigma,w,h,nhinc,nwinc,rh,rw)
		* Generates a struct with the coil geometry and general propierties
	* Discretization Tools:		[nhinc,nwinc]=optimize_discr(w,h,rh,rw,delta)
		* Calculates a mesh discretization that allows a delta width filament in the edges of the geometry
	* FastHenry Creator:		file_name=fasthenry_creator(file_name,coils,freq)
		* Creates a .inp file containing all the geometry and conductor data.
	* FastHenry Runner:		[L,R,Frequency]=fasthenry_runner(file_name,directives,show)
		* Runs the fasthenrymodel and retrives the results
	* FastCap Creator:		file_name=fastcap2_creator(in_file_name,out_file_name,permitivity, command)
		* Creates a .list and .que files containing the fastcap surfaces
	* FastCap Runner:		fastcap2_runner(file_name,directives,show)
		* Runs the fastcap model and retrieves the maxwell capacitance matrix
### Utilities:
	* Import Bode100:		data=import_bode100(filename)
		* Imports data from a csv file generated with bode100 suite
	* Generate Model Bode100:	model=model_bode100(data,freq_L)
		* Takes data imported from bode100 and generates a model taht matches the data
	* Real Coil:			[Rs, Ls, fres]=real_coil(L,R,C,f)
		* Takes parameters from a model and calculates the series impedance equivalents
	* Import raw LTSpice:		raw_data = LTspice2Matlab( filename, varargin )
		* Takes a .raw file from a Spice simulation and imports it as a struct
	* Run LTSpice			raw_data=LTautomation(file_name)
		* Runs a .asc LTSpice simulation file 
	* Modify LTSpice		component_find = LTmodify( file_name, component, value )
		* Looks for a omponent in a .asc file and modifies its value

## TaskList
	- [x] Tipical Planar Geometries
	- [x] Tipical Helicoidal Geometries
	- [X] Interface with FastHenryV2
	- [X] Interface with LTSpice
	- [] Interface with FastCapV2
	- [] Implement Tools for numerical maxwell calculations
	- [] Do a guide 
	- [] Only use model and data structs to interface
