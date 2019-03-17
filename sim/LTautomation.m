system('spice.bat')
A=LTspice2Matlab('WPT_GaN_auto.raw')
plot(A.time_vect, A.variable_mat(9,:))