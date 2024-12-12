/// @description scr_smoothStep(min, max, value);
/// @param min
/// @param max
/// @param value
function scr_smoothStep(argument0, argument1, argument2) {

	var value = clamp((argument2 - argument0) / (argument1 - argument0), 0, 1);
	return (value * value * (3 - 2 * value));


}
