/// @description scr_uiDrawElementBox(x,y,x2,y2,state);
/// @param x
/// @param y
/// @param x2
/// @param y2
/// @param state
function scr_uiDrawElementBox(argument0, argument1, argument2, argument3, argument4) {

	var subImg = argument4;
	var ww = argument2 - argument0;
	var hh = argument3 - argument1;

	var xscale = (ww - 6) / 3;
	var yscale = (hh - 6) / 3;

	draw_sprite_part(spr_GUI_9Slice, subImg, 0,0,3,3,argument0,argument1); // Top-Left corner
	draw_sprite_part(spr_GUI_9Slice, subImg, 6,0,3,3,argument2 - 3,argument1); // Top-Right corner	
	draw_sprite_part(spr_GUI_9Slice, subImg, 0,6,3,3,argument0,argument3 - 3); // Bottom-Left corner
	draw_sprite_part(spr_GUI_9Slice, subImg, 6,6,3,3,argument2 - 3,argument3 - 3); // Bottom-Right corner


	draw_sprite_part_ext(spr_GUI_9Slice, subImg,3,0,3,3,argument0 + 3, argument1, xscale, 1, c_white, 1); //Top Edge
	draw_sprite_part_ext(spr_GUI_9Slice, subImg,0,3,3,3,argument0, argument1 + 3, 1, yscale, c_white, 1); //Left Edge
	draw_sprite_part_ext(spr_GUI_9Slice, subImg,3,6,3,3,argument0 + 3, argument3 - 3, xscale, 1, c_white, 1); //Bottom Edge
	draw_sprite_part_ext(spr_GUI_9Slice, subImg,6,3,3,3,argument2 - 3, argument1 + 3, 1, yscale, c_white, 1); //Right Edge

	draw_sprite_part_ext(spr_GUI_9Slice, subImg,3,3,3,3,argument0 + 3, argument1 + 3, xscale, yscale, c_white, 1); //Fill




}
