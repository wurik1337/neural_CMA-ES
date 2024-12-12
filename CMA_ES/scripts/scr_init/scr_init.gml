/// @description scr_init();
function scr_init() {

	/*	**Optional** 
		Basic project initialization for obj_lineGraph.
	*/

	// May reduce performance
	display_reset(8, 0); // Vastly reduces aliasing of grid geometry. (Sets geometry anti-aliasing to 8x)

	gpu_set_texfilter(1);


}
