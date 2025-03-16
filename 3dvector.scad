use <hsvtorgb.scad>

/*Example*/
drawArrowChain_3DVector([[0,0,30],[-5,5,8],[-5,5,0],[-5,5,-8],[-1,1,-30],[-1,1,30],[-5,5,8],[-5,5,0],[-5,5,-8],[0,0,-30]], [15,-15,0]);


function magnatude_3DVector(v) = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);

function angleBetween_3DVector(u, v) = acos((u * v) / (magnatude_3DVector(u) * magnatude_3DVector(v)));

function normalize_3DVector(v) = [v[0]/magnatude_3DVector(v), v[1]/magnatude_3DVector(v), v[2]/magnatude_3DVector(v)];

function dotProduct_3DVector(u, v) = u * v;

function crossProduct_3DVector(u, v) = [u[1]*v[2] - v[1]*u[2], u[2]*v[0] - v[2]*u[0], u[0]*v[1] - v[0]*u[1]]; 
	
function rotMatrix_3DVector(axis, angle) =	[
												[
													((1 - cos(angle)) * pow(axis[0], 2)) + cos(angle),
													((1 - cos(angle)) * axis[0] * axis[1]) - (sin(angle) * axis[2]),
													((1 - cos(angle)) * axis[0] * axis[2]) + (sin(angle) * axis[1])
												],
												[
													((1 - cos(angle)) * axis[0] * axis[1]) + (sin(angle) * axis[2]),
													((1 - cos(angle)) * pow(axis[1], 2)) + cos(angle),
													((1 - cos(angle)) * axis[1] * axis[2]) - (sin(angle) * axis[0])
												],
												[
													((1 - cos(angle)) * axis[0] * axis[2]) - (sin(angle) * axis[1]),
													((1 - cos(angle)) * axis[1] * axis[2]) + (sin(angle) * axis[0]),
													((1 - cos(angle)) * pow(axis[2], 2)) + cos(angle)
												]
											];

function rotAxisAngle_3DVector(vec, axis, angle) = rotMatrix_3DVector(normalize_3DVector(axis), angle) * vec;

function trackTo_3DVector(cur, tar, influence) = rotAxisAngle_3DVector(cur, crossProduct_3DVector(cur, tar), angleBetween_3DVector(cur, tar) * influence);

function random_3DVector(seed = undef) =	[
												seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed - 100)[0])[0],
												seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed)[0])[0],
												seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed + 100)[0])[0]
											];
											
											
module drawArrow_3DVector
(
	vector = [10, 10, 10],
	root = [0, 0, 0],
	color_from_magnatude = true,
	magnatude_range = 100,
	radius_from_magnatude = true,
	manual_radius = 1,
	res = 16
)
{
	

	xyLength = sqrt(pow(vector[0], 2) + pow(vector[1], 2));
	
	magnatude = abs(sqrt(pow(vector[0], 2) + pow(vector[1], 2) + pow(vector[2], 2)));
	
	radius = radius_from_magnatude == true ? magnatude * .05 : manual_radius;
	
	zAngle = xyLength == 0 ? vector[0] > 0 ? 90 : -90 : acos(vector[1] / xyLength);
	
	xAngle = acos(xyLength / magnatude);
	
	realxAngle = vector[2] > 0 ? xAngle : -xAngle;
	
	realzAngle = vector[0] > 0 ? -zAngle : zAngle;
	
	vecRot = [realxAngle,realzAngle];
	
	//we move the vector to start at the root location
	translate(root)
	
	//we use the vector's magnatude compared to the magnatude_range to set the color
	color(hsvToRGB(magnatude / magnatude_range * 360,1,1,1))
	{
		//we start with the vector point along the y axis and then rotate it into place
		rotate([0, 0, vecRot[1]])
		{
			rotate([vecRot[0], 0, 0])
			{
				rotate([-90, 0, 0])
				{
					//point of the arrow
					translate([0,0,magnatude - radius * 3])
						cylinder(r1 = radius * 1.5, r2 = 0, h = radius * 3, $fn = res);
				
					//shaft of the arrow
					cylinder(r = radius, h = magnatude - radius * 3, $fn = res);
				}
			}
		}
	}
}

module drawArrowChain_3DVector
(
	my_vectors = [[10,10,10],[-10,20,10],[-30,-10,10],[0,0,-20]],
	root = [0, 0, 0],
	iterations_left
)
{
	iterations = iterations_left == undef ? len(my_vectors) : iterations_left;

	cur_pos = root + my_vectors[len(my_vectors) - iterations];
// 	echo("cur_pos", cur_pos);

	drawArrow_3DVector(my_vectors[len(my_vectors) - iterations], root);

	if(iterations > 1)
	{
		drawArrowChain_3DVector
		(
			my_vectors,
			cur_pos,
			iterations - 1
		);
	}
}