// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function NeuronColor(value) {
	value		= Tanh(value);
	var red		= (abs(value) - value) * 111+16;
	var green	= (abs(value) + value) * 111+16;
	var blue	= (abs(value)) * 111 + 32;
	return make_color_rgb( red, green, blue);
} 