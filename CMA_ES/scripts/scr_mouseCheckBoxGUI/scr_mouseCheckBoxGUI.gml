/// @description scr_mouseCheckBoxGUI(x1,x2,y1,y2);
/// @param x1 
/// @param x2
/// @param y1
/// @param y2
function scr_mouseCheckBoxGUI(argument0, argument1, argument2, argument3) {

	
	var r = 0;
	if (window_mouse_get_x() > argument0)
		{
		if (window_mouse_get_x() < argument1)
			{
			if (window_mouse_get_y() > argument2)
				{
				if (window_mouse_get_y() < argument3)
					{
					r = 1;
					}
				}
			}
		}
	
	return (r);


}
