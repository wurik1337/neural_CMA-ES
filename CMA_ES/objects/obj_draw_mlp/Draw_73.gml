/// @desc DRAW MLP

if (!is_undefined(target))
and (instance_exists(target)) {
	
	// Draw network
	var mlp = target.network;

	var iEnd, jEnd;
		iEnd = mlp.layerCount;
	var xStart, yStart, xx, yy, w, h, d, color;
		w = 20;
		h = 14;
		d = 2;
		xStart = x - (w + d) * (iEnd-1) / 2;
		yStart = y - h/2;
	
	// Draw neuron outputs.
	for(var i = 0; i < iEnd; i++) {
		jEnd = mlp.layerSizes[i];
		yy = yStart - (h + d) * jEnd / 2;
		
		for(var j = 0; j < jEnd; j++) {
			xx = xStart + i * (w + d);
			yy += (h + d);
			color = NeuronColor(mlp.output[i][j]*4);
			draw_sprite_ext(spr_example_pixel, 0, xx, yy, w, h, 0, color, 1);
		}
	}
}