/// @desc V2D (2D vector) struct
// 
// This is a simple 2D vector struct
// Created (C) 2020 by: Troy Barlow
// FREE to use but keep my name in source code

/// @func function V2D(_x, _y) constructor
/// @desc Construct a V2D (2D vector) given _x and _y coordinates: myvar = new V2D(1,1);
/// @param {real} _x X location of vector terminal point
/// @param {real} _y Y location of vector terminal point
/// @return {struct} The new V2D
function V2D(_x, _y) constructor
{
	x = _x;
	y = _y;
   
    // Operations
	
	// Same as doing a scalar multiplication by -1. It will return a vector with the direction flipped 180 degrees
	/// @func negate() 
	/// @desc Flip the direction of this vector so it points in opposite direction
	negate = function() { x = -x; y = -y; }
	// Add another vector to this one
	/// @func add(_v2d) 
	/// @desc Add another vector to this one
	/// @param {v2d} V2D vector to add
    add = function( v2d ) { x += v2d.x; y += v2d.y; }    
	// Subtract another V2D to this one
	/// @func sub(_other) 
	/// @desc Subtract another vector from this one
	/// @param {v2d} V2D vector to subtract
    sub = function( v2d ) { x -= v2d.x; y -= v2d.y; }    
	// Scale this vector by a value
	/// @func scale(scalar) 
	/// @desc Scale this vector's mangnitude/length
	/// @param {real} scalar Value to scale it by
	scale = function( scalar ) { x *= scalar; y *= scalar; }    
	// Rotate this vector counter clockwise by _degrees
	/// @func rotate(_degrees) 
	/// @desc Rotate this vector counter-clockwise by _degrees
	/// @param {real} _degrees Amount to rotate
	rotate = function( _degrees ) 
	{
		// multiply degrees * PI / 180 to convert to radians.
		var theta = _degrees * pi / 180.0; 
		var c = cos(theta);
		var s = sin(theta);
		var tx = x * c - y * s;
		var ty = x * s + y * c;
		x = tx;
		y = ty;
	}
	// Return the magnitude/length of this vector
	/// @func magnitude() 
	/// @desc Return the magnitude/length of this vector
	/// @return {real} The magnitude
	magnitude = function() { return sqrt(x * x + y * y); }
	// Convert this vector into a unit vector (same direction as before, but a magnitude of 1)
	/// @func normalize() 
	/// @desc Convert this vector into a unit vector
	normalize = function() 
	{  
		var mag = magnitude();
		if (0 == mag) return 0;
		x /= mag;
		y /= mag;
		return mag;
	}
	// Return the direction in degrees of this vector (0 = right, 90 = up, 180 = left, 270 = down)
	/// @func dir
	/// @desc Return the direction of this vector (0 = right, 90 = up, 180 = left, 270 = down)
	/// @return {real} The direction in degrees
	dir = function() 
	{
		var theta = arctan2(y, x) * 180.0 / pi;
		if ( y < 0 )
			theta += 360.0; 
		return theta == 360 ? 0: theta;
	}
	
	// Override default behavior of string()
	toString = function() { return "V2D<" + string(x) + "," + string(y) + ">"; }
}

// ------------------------------------- V2D Helpers

/// Return the distance from this _v1 to _v2
/// @func function distV2D(_v1, _v2) 
/// @desc Return the distance from _v1 to _v2
/// @param {V2D} _v1 First vector
/// @param {V2D} _v2 Second vector
/// @return {real} The distance
function distV2D( _v1, _v2 )
{
	return sqrt((_v2.x - _v1.x) * (_v2.x - _v1.x) + (_v2.y - _v1.y) * (_v2.y - _v1.y));
}	

// Cross product of two vectors
// + Cross product is NOT commutative : AcrossB != BcrossA
// Returns 0 if _v1 and _v2 are facing the exact same direction or are 180 degrees apart
// Positive crossproduct if _v1 is on the right side of _v2
// Negative crossproduct if _v1 is on the left side of _v2
/// @func function crossV2D(_v1, _v2) 
/// @desc Return the cross product of two vectors _v1 cross _v2
/// @param {V2D} _v1 First vector
/// @param {V2D} _v2 Second vector
/// @return {real} The cross product (0 = if parallel,postive if _v1 is right of _v2, negative if _v1 is left of _v2
function crossV2D(_v1, _v2) { return _v1.x * _v2.y - _v1.y * _v2.x; }

// Return the angle in degrees between two vectors (-179 to 180) 
// Positive result if v1 is to the right of v2
// Negative result if v1 is to the left of v2. 
/// @func function anglV2De(_v1, _v2) 
/// @desc Return the the angle between _v1 and _v2
/// @param {V2D} _v1 First vector
/// @param {V2D} _v2 Second vector
/// @return {real} The angle (-179 (left) to 0 (same) to 180 (right)) 
function angleV2D( _v1, _v2 )
{
	var v1crossv2 = crossV2D(_v1, _v2);
	if (0 == v1crossv2) return 0;
	var theta = arctan2(v1crossv2, dotV2D(_v1, _v2)) * 180.0 / pi;
	return theta;
}

// Dot product of two vectors
// If the dot product is 0, the vectors are perpendicular/orthogonal 
// If the dot product is positve, the vectors are pointing in similar directions(acute angles).
// If the dot product is negative, the vectors are pointing in nearly opposite directions(obtuse angles).
//
// Note: Any vector dotted with itself (AdotA) gives us its magnitude squared. 
// So if A is a unit vector, AdotA = 1
/// @func function dotV2D(_v1, _v2) 
/// @desc Return the dot product of two vectors _v1 dot _v2
/// @param {V2D} _v1 First vector
/// @param {V2D} _v2 Second vector
/// @return {real} The dot product (0 = perpendicular,postive if within 180 degrees, negative if > 180 degrees
function dotV2D(_v1, _v2) { return _v1.x * _v2.x + _v1.y * _v2.y; }

/// Calculate the projection vector of _V onto _N - the length  of the shadow/projection that V would cast along the N vector. 
/// Basically the returned vector will be the "adjacent" side of the triangle formed by V and N
/// @func function projectV2D(_V, _N, _N_Is_UnitVector) 
/// @desc Calculate the projection vector of _V onto _N
/// @param {V2D} _V First vector
/// @param {V2D} _N Second vector
/// @return {bool} _N_Is_UnitVector True if _N is a unit vector (faster if it is)
/// @return {V2D} The projection vector
function projectV2D(_V, _N, _N_Is_UnitVector)
{
	// Formula = (VdotN / NdotN)N
	var scalar;

	if ( !_N_Is_UnitVector )
		scalar = dotV2D(_V, _N) / dotV2D(_N, _N);
	else
		scalar = dotV2D(_V, _N);

	return new V2D( _N.x * scalar, _N.y * scalar);
}

/// Calculate the rejection vector of _V onto _N  - Basically the returned vector will be the "opposite" side of the triangle formed by V and N
/// @func function rejectV2D(_V, _N, _N_Is_UnitVector)
/// @desc Calculate the rejection vector of _V onto _N
/// @param {V2D} _V First vector
/// @param {V2D} _N Second vector
/// @return {bool} _N_Is_UnitVector True if _N is a unit vector (faster if it is)
/// @return {V2D} The rejection vector
function rejectV2D(_V, _N, _N_Is_UnitVector) 
{ 
	// Formula = V - (VdotN / NdotN)N
	var scalar;
	
	if ( !_N_Is_UnitVector )
		scalar = dotV2D(_V, _N) / dotV2D(_N, _N);
	else
		scalar = dotV2D(_V, _N);

	
	return new V2D( _V.x - (_N.x * scalar), _V.y - (_N.y * scalar) );
} 

/// Reflect vector _V off surface vector _N (useful for a bounce vector)
/// @func reflectV2D(_V, _N, _N_Is_UnitVector) 
/// @desc Reflect vector _V off surface vector _N
/// @param {V2D} _V Vector you want to reflect onto _N
/// @param {V2D} _N Vector you want to reflect onto (usually this is a surface normal)
/// @return {bool} _N_Is_UnitVector True if _N is a unit vector (faster if it is)
/// @return {V2D} The resulting reflection vector
function reflectV2D(_V, _N, _N_Is_UnitVector) 
{
	// Formula = V - 2(VdotN / NdotN)N
	var scalar;

	if ( !_N_Is_UnitVector )
		scalar = 2 * (dotV2D(_V, _N) / dotV2D(_N, _N));
	else
		scalar = 2 * dotV2D(_V, _N);

	return new V2D( _V.x - (_N.x * scalar), _V.y - (_N.y * scalar));
}
