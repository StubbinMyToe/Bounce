/// @description Draw info and lines
draw_self();

draw_text_colour(0,0,"Incoming Vector = " + string(V),c_green,c_green,c_green,c_green,1);
draw_text(0,15,"Surface Normal = " + string(N));
draw_text_colour(0,30,"Reflected Vector = " + string(R),c_red,c_red,c_red,c_red,1);
draw_text_colour(0,45,"Surface Angle (use arrow keys) = " + string(abs(image_angle)), c_blue, c_blue, c_blue, c_blue, 1);

draw_line_colour(x,y,x+V.x,y+V.y,c_green,c_green);
draw_line_colour(x,y,x+N.x * 30,y+N.y * 30,c_white,c_white);
draw_line_colour(x,y,x+R.x,y+R.y,c_red,c_red);

