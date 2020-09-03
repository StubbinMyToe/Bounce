/// @description Update vectors

// Check input
var left = keyboard_check(vk_left);
var right = keyboard_check(vk_right);
if ( left )
{
	image_angle++;
	if ( abs(image_angle) > 359 )
	  image_angle = 0;
}
else if (right)
{
	image_angle--;
	if ( abs(image_angle) > 359 )
	  image_angle = 0;
}

// Update incoming vector to be from mouse position to the origin of surface
V.x = mouse_x - x;
V.y = mouse_y - y;

// Calculate the surface normal
// Get surface direction
N.x = 1;
N.y = 0;
N.rotate(-image_angle);
// Create surface normal (perpendicular to the surface) (clockwise)
N = new V2D( N.y, -N.x );

// Since V is an incoming vector, we need to flip it so that its tail is the same as N
temp = new V2D( V.x * -1, V.y * -1 );
// Calculate Reflection
R = reflectV2D(temp,N,false);
