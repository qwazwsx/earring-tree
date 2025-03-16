// This work is based on "Customizable Tree" by Thingiverse, originally licensed under CC BY-SA 3.0.  
// It has been upgraded to CC BY-SA 4.0 and is now licensed under GNU GPL 3.0 or later.  
//  
// Original "Customizable Tree": https://www.thingiverse.com/thing:279864  
// Modified version ("Earring Stand"): https://github.com/qwazwsx/earring-tree  
//  
// Per the terms of CC BY-SA 4.0, this work has been relicensed under GNU GPL 3.0+.  
// Attribution to the original creator is required under both licenses.
use <Write.scad>
use <hsvtorgb.scad>
use <3dvector.scad>


/**************************************************************************************/
/*							 		Customizer Controls								  */
/**************************************************************************************/

//preview[view:south, tilt:top diagonal]

/*[Tree]*/
//Use the Tabs above to play with different settings!

//The number of times that branches will iterate. Controls how many levels of branches there are.
maximum_branching_iterations = 3; //[3,4]

//The radius of the bottom of the trunk of the tree in mm
trunk_radius = 30; //[10:35]

// how many mm from the end of a terminal branch to place a hole for the earring to go through. This is used to make sure the hole is not too close to the end of the branch.
hole_offset = 3; //[0:10]


/*[Branches]*/

//Controls the minimum number of branches that will generate from each branch
min_number_of_branches_from_each_branch = 3; //[1:4]

//Controls the maximum number of branches that will generate from each branch
max_number_of_branches_from_each_branch = 4; //[2:5]

//How far along a branch do new branches start splitting off
start_budding_position = 100; //[0:100]

//How far along a branch do new branches stop splitting off
stop_budding_position = 100; //[0:100]

//How much are the branches twisted?
branch_twist_angle = 90; //[0:90]

//Do lower branches keep growing after they have started branching? Usually results in a fuller tree.
branches_keep_growing = 1; //[1:Yes, 0:No]


/*[Shape]*/

//Pick a shape for your trunk and branches. Select "Custom" to draw your own below!
branch_cross_section_shape = 8; //[3:Triangle,4:Square,5:Pentagon,6:Hexagon,8:Octagon,32:Circle,0:Custom]

custom_shape = [[[0.000000,46.278908],[-15.319993,17.365068],[-47.552826,11.729756],[-24.788267,-11.775289],[-29.389259,-44.171944],[0.000001,-29.785017],[29.389269,-44.171940],[24.788267,-11.775290],[47.552826,11.729764],[15.319985,17.365074]],[[0,1,2,3,4,5,6,7,8,9]]]; //[draw_polygon:100x100]

//Pick a shape for your base
base_shape = 0; //[3:Triangle,4:Square,5:Pentagon,6:Hexagon,8:Octagon,32:Circle,0:Use Same Shape as Branch]

// Pick a size for the base
base_size = 140; // [0:1000]

/*[Overhangs]*/

//If you set this to Yes, you'll need to print with supports
allow_all_overhangs = 0; //[0:No, 1:Yes]

//If the previous control is set to No, how much overhang angle, in degrees, do you want to allow?
allowed_overhang_angle = 50; //[30:65]

/*[Tray]*/

// if we want to create a tray at the base of the tree (for earring backs)
create_tray = 1; //[0:No, 1:Yes]
// the depth of the tray in mm
tray_depth = 5; //[0:10]
// the width of the walls of the tray in mm
tray_wall_width = 3; //[0:10]

/*[Variation]*/

//Change this to get different variants based on your inputs.
seed = 0; //[0:360]

/*[Advanced Settings]*/

//These controls can result in trees which are unprintable or very difficult to print, but also allow for a wider variety of shaped trees. Only use these if you are willing to experiment.
use_advanced_settings = 0; //[0:No,1:Yes]

//these settings control the range of how big a new branch's base diameter is compared to its parents base diameter
root_min_ratio = 50; //[1:100]
root_max_ratio = 60; //[1:100]

//these settings control the range of how big a new branch's tip diameter is compared to its own base diameter
tip_min_ratio = 50;	//[1:100]
tip_max_ratio = 70;	//[1:100]

//these settings control the range of how long a new branch is compared to its parent branch
length_min_ratio = 70;	//[1:100]
length_max_ratio = 100;	//[1:100]

//these settings control the range of angles that a new branch will diverge from its parent branch. this number will get modified to ensure proper overhangs if the "allow all overhangs" option is turned off.
min_branching_angle = 40; //[0:360]
max_branching_angle = 55; //[0:360]

//this value is used to test if branches are above a minimum printable feature size in mm. you can set this lower if your printer can handle tiny towers. we don't suggest setting this smaller than your_nozzle_diameter X 2.
branch_diameter_cutoff = 1.6;

//this controls the length of the trunk of the tree
trunk_length = 40; //[10:60]


/*[Hidden]*/
//The size of the bounding box around the stand of the tree
// base_size = ;
my_root_min_ratio = use_advanced_settings == 1 ? root_min_ratio / 100 : .5;
my_root_max_ratio = use_advanced_settings == 1 ? root_max_ratio / 100 : .6;
my_tip_min_ratio = use_advanced_settings == 1 ? tip_min_ratio / 100 : .5;
my_tip_max_ratio = use_advanced_settings == 1 ? tip_max_ratio / 100 : .7;
my_length_min_ratio = use_advanced_settings == 1 ? length_min_ratio / 100 : .7;
my_length_max_ratio = use_advanced_settings == 1 ? length_max_ratio / 100 : .9;
my_min_branching_angle = use_advanced_settings == 1 ? min_branching_angle : 45;
my_max_branching_angle = use_advanced_settings == 1 ? max_branching_angle : 55;
my_branch_diameter_cutoff = use_advanced_settings == 1 ? branch_diameter_cutoff : 1.6;
my_trunk_length = use_advanced_settings == 1 ? trunk_length : 75;

/**************************************************************************************/
/*											Code									  */
/**************************************************************************************/

// This section creates the tree's platform based on the selected base shape

// If a predefined base shape is selected (base_shape > 0)
if(base_shape > 0)
{
    // Extrude a circle with the specified radius and number of facets
    linear_extrude(height = 1)
        circle(r = base_size / 2, $fn = base_shape);

}
else
{
    // If no predefined base shape is selected, use the branch cross-section shape
    if(branch_cross_section_shape > 0)
    {
        // Extrude a circle with the specified radius and number of facets
        linear_extrude(height = 1)
            circle(r = base_size / 2, $fn = branch_cross_section_shape);

        if (create_tray){
            difference() {
                linear_extrude(height = tray_depth)
                    circle(r = base_size / 2, $fn = branch_cross_section_shape);

                linear_extrude(height = tray_depth + 1) // add 1 to avoid weird zfighting in preview
                    circle(r = (base_size / 2) - tray_wall_width, $fn = branch_cross_section_shape);
            }
        }
    }
    else
    {
        // If a custom shape is defined with less than 32 points
        if(len(custom_shape[0]) < 32)
        {
            // Extrude the custom polygon shape after scaling it to the base size
            linear_extrude(height = 1)
                scale([1 / 100 * base_size, 1 / 100 * base_size])
                    polygon(points=custom_shape[0], paths=[custom_shape[1][0]]);
        }
        else
        {
            // If the custom shape has 32 or more points, reduce it to 32 points and extrude
            linear_extrude(height = 1)
                scale([1 / 100 * base_size, 1 / 100 * base_size])
                    polygon(points=reduce_shape_to_32_points(custom_shape)[0], paths=reduce_shape_to_32_points(custom_shape)[1]);
        }

        if (create_tray){
            assert(false, "Custom shapes + tray not implemented yet. PR's welcome!"); // TODO: implement this
        }
    }
}
// This makes the tree itself
difference()
{
    // If a predefined branch cross-section shape is selected (branch_cross_section_shape > 0)
    if(branch_cross_section_shape > 0)
    {
        // Draw the vector branch from the polygon with the specified parameters
        draw_vector_branch_from_polygon
        (
            iterations_total = maximum_branching_iterations,
            iterations_left = maximum_branching_iterations,

			// vector pointing straight up, for the trunk
            direction = [0,0,1],
            root = [0, 0, 0],
    
            polygon_bounding_size = [trunk_radius * 2, trunk_radius * 2],
            twist = branch_twist_angle,
    
            branch_root_min_scale_ratio = my_root_min_ratio,
            branch_root_max_scale_ratio = my_root_max_ratio,
    
            branch_tip_min_scale_ratio = my_tip_min_ratio,
            branch_tip_max_scale_ratio = my_tip_max_ratio,
    
            branch_min_lengh_ratio = my_length_min_ratio,
            branch_max_lengh_ratio = my_length_max_ratio,
    
            min_branching = min_number_of_branches_from_each_branch,
            max_branching = max_number_of_branches_from_each_branch,
    
            min_branching_angle = my_min_branching_angle,
            max_branching_angle = my_max_branching_angle,
    
            budding_start_ratio = start_budding_position / 100,
            budding_end_ratio = (stop_budding_position > start_budding_position ? stop_budding_position : start_budding_position) / 100,
        
            extend_branch = branches_keep_growing,
    
            overhangs_allowed = allow_all_overhangs,
            overhang_angle_cutoff = allowed_overhang_angle,
    
            branch_cross_section_bounds_size_cutoff = my_branch_diameter_cutoff,
    
            last_branch_root_scale = 1,
            last_branch_length = my_trunk_length,
    
            random_seed = false,
            manual_seed = seed
        )
        {
            // Rotate the branch and draw a circle with the specified radius and number of facets
            rotate([0,0,90])
            circle(r = trunk_radius, $fn = branch_cross_section_shape);
        }
    }
    else
    {
        // If no predefined branch cross-section shape is selected
        if(len(custom_shape) == 0)
        {
            // Display a message to draw a shape
            assert(false, "Please draw a shape in the custom_shape variable to use this option.");
        }
        else
        {
            // If a custom shape is defined with 32 or fewer points
            if(len(custom_shape[1][0]) <= 32)
            {	
                // Draw the vector branch from the custom polygon with the specified parameters
                draw_vector_branch_from_polygon
                (
                    iterations_total = maximum_branching_iterations,
                    iterations_left = maximum_branching_iterations,

                    direction = [0,0,1],
                    root = [0, 0, 0],
    
                    polygon_bounding_size = [trunk_radius * 2, trunk_radius * 2],
                    twist = branch_twist_angle,
    
                    branch_root_min_scale_ratio = my_root_min_ratio,
                    branch_root_max_scale_ratio = my_root_max_ratio,
    
                    branch_tip_min_scale_ratio = my_tip_min_ratio,
                    branch_tip_max_scale_ratio = my_tip_max_ratio,
    
                    branch_min_lengh_ratio = my_length_min_ratio,
                    branch_max_lengh_ratio = my_length_max_ratio,
    
                    min_branching = min_number_of_branches_from_each_branch,
                    max_branching = max_number_of_branches_from_each_branch,
    
                    min_branching_angle = my_min_branching_angle,
                    max_branching_angle = my_max_branching_angle,
    
                    budding_start_ratio = start_budding_position / 100,
                    budding_end_ratio = (stop_budding_position > start_budding_position ? stop_budding_position : start_budding_position) / 100,
    
                    extend_branch = branches_keep_growing,
    
                    overhangs_allowed = allow_all_overhangs,
                    overhang_angle_cutoff = allowed_overhang_angle,
    
                    branch_cross_section_bounds_size_cutoff = my_branch_diameter_cutoff,
    
                    last_branch_root_scale = 1,
                    last_branch_length = my_trunk_length,
    
                    random_seed = false,
                    manual_seed = seed
                )
                {
                    // Scale and rotate the custom polygon shape
                    scale([1 / 50 * trunk_radius, 1 / 50 * trunk_radius])
                        rotate([0,0,90])
                        polygon(points=custom_shape[0], paths=[custom_shape[1][0]]);
                }
            }
            else
            {
                // If the custom shape has more than 32 points, reduce it to 32 points and draw the vector branch
                draw_vector_branch_from_polygon
                (
                    iterations_total = maximum_branching_iterations,
                    iterations_left = maximum_branching_iterations,

                    direction = [0,0,1],
                    root = [0, 0, 0],
    
                    polygon_bounding_size = [trunk_radius * 2, trunk_radius * 2],
                    twist = branch_twist_angle,
    
                    branch_root_min_scale_ratio = my_root_min_ratio,
                    branch_root_max_scale_ratio = my_root_max_ratio,
    
                    branch_tip_min_scale_ratio = my_tip_min_ratio,
                    branch_tip_max_scale_ratio = my_tip_max_ratio,
    
                    branch_min_lengh_ratio = my_length_min_ratio,
                    branch_max_lengh_ratio = my_length_max_ratio,
    
                    min_branching = min_number_of_branches_from_each_branch,
                    max_branching = max_number_of_branches_from_each_branch,
    
                    min_branching_angle = my_min_branching_angle,
                    max_branching_angle = my_max_branching_angle,
    
                    budding_start_ratio = start_budding_position / 100,
                    budding_end_ratio = (stop_budding_position > start_budding_position ? stop_budding_position : start_budding_position) / 100,
    
                    extend_branch = branches_keep_growing,
    
                    overhangs_allowed = allow_all_overhangs,
                    overhang_angle_cutoff = allowed_overhang_angle,
    
                    branch_cross_section_bounds_size_cutoff = my_branch_diameter_cutoff,
    
                    last_branch_root_scale = 1,
                    last_branch_length = my_trunk_length,
    
                    random_seed = false,
                    manual_seed = seed
                )
                {
                    // Scale and rotate the reduced custom polygon shape
                    scale([1 / 50 * trunk_radius, 1 / 50 * trunk_radius])
                        rotate([0,0,90])
                        polygon(points=reduce_shape_to_32_points(custom_shape)[0], paths=[reduce_shape_to_32_points(custom_shape)[1][0]]);
                }
            }
        }
    }
    // Translate and create a cube to represent the base of the tree
    // the vectors always point up so I don't know why we do this
    translate([0,0,-150])
        cube([300,300,300], center = true);
}


/**************************************************************************************/
/*									Modules and Functions							  */
/**************************************************************************************/
module draw_vector_branch_from_polygon
(
    iterations_total = 5,
    iterations_left = 5,

    direction = [0,0,1],
    root = [0, 0, 0],
    
    polygon_bounding_size,
    twist = 0,
    
    branch_root_min_scale_ratio = .5,
    branch_root_max_scale_ratio = .6,
    
    branch_tip_min_scale_ratio = .5,
    branch_tip_max_scale_ratio = .7,
    
    branch_min_lengh_ratio = .7,
    branch_max_lengh_ratio = .9,
    
    min_branching = 2,
    max_branching = 3,
    
    min_branching_angle = 40,
    max_branching_angle = 55,
    
    budding_start_ratio = .5,
    budding_end_ratio = 1,
    
    extend_branch = true,
    
    overhangs_allowed = false,
    overhang_angle_cutoff = 65,
    
    branch_cross_section_bounds_size_cutoff = 1.6,
    
    last_branch_root_scale = 1,
    last_branch_length = 40,
    
    random_seed = false,
    manual_seed = 0
)
{
    // Determine the seed for random number generation
    my_seed = random_seed == true ? rands(0, 10000, 1)[0] : manual_seed;
    
    // Calculate the current iteration
    current_iteration = iterations_total - iterations_left;

    _iterations_left = iterations_left;
    _iterations_total = iterations_total;

    // Calculate the length of the current branch
    my_length = last_branch_length * rands(branch_min_lengh_ratio, branch_max_lengh_ratio, 1, my_seed)[0];
    
    // Calculate the scale of the root of the current branch
    my_root_scale = last_branch_root_scale * rands(branch_root_min_scale_ratio, branch_root_max_scale_ratio, 1, my_seed)[0];

    // Calculate the scale of the tip of the current branch
    my_tip_scale = rands(branch_tip_min_scale_ratio, branch_tip_max_scale_ratio, 1, my_seed)[0];
    
    my_direction = direction;
    
    // Normalize the direction vector and scale it by the branch length
    my_vector = normalize_3DVector(my_direction) * my_length;
    
    my_root = root;
    
    polygon_size = polygon_bounding_size;

    my_twist = twist;

    // Determine the number of branches to generate
    num_branches = floor(rands(min_branching, max_branching + .9999, 1, my_seed)[0]);

    // Generate random branching angles for the new branches
    new_branches_branching_angle = rands(min_branching_angle, max_branching_angle, num_branches, my_seed);
    
    // Generate random budding positions for the new branches
    new_branches_budding_positions = rands(budding_start_ratio, budding_end_ratio , num_branches, my_seed);
    
    // Calculate the size of the tip of the current branch
    my_tip_size = my_tip_scale * my_root_scale * polygon_size;
    
    my_extend_branch = extend_branch;
    
    // Check if the tip size is above the cutoff
    if(!(my_tip_size[0] < branch_cross_section_bounds_size_cutoff || my_tip_size[1] < branch_cross_section_bounds_size_cutoff))
    {
        // Check if the polygon size is defined
        if(polygon_size != undef)
        {		
            difference(){
                // Draw the capped vector from the polygon
                    
                draw_capped_vector_from_polygon
                (
                    my_vector,
                    my_root,
                    my_tip_scale,
                    twist_poly = twist,
					iterations_left = iterations_left,
                    cap_size = my_tip_size
                )
                    // Scale the root of the branch
                    scale(my_root_scale)
                        children();

                // Compute normalized branch direction.
                norm_dir = normalize_3DVector(my_direction);

                // Compute the translation: 5 mm from the end of the branch.
                trans_pos = my_root + my_vector - norm_dir * hole_offset;

                // color([1,1,1,1])
                // drawArrow_3DVector
                // (
                //     vector = norm_dir * my_length,
                //     root = my_root,
                //     // manual_radius = 100,
                //     res = 16
                // );

                if (iterations_left == 0){

                    // For nearly vertical branches, use a fixed rotation.
                    if (abs(norm_dir[2]) > 0.9) {
                        translate(trans_pos)
                            // Rotate about X to make the cylinder horizontal.
                            rotate([0,90,0])
                            cylinder(h = 10, r =  my_tip_size * my_tip_scale, center = true, $fn = 32);
                    } else {
                        // Compute the rotation that would align [0,0,1] (default cylinder axis) with the branch direction.
                        rot_axis1 = crossProduct_3DVector([0,0,1], norm_dir);
                        rot_angle1 = acos(dotProduct_3DVector([0,0,1], norm_dir));
                    

                        // First rotate to align the cylinder with the branch, then rotate 90° about the branch axis so that
                        // the cylinder's long axis becomes perpendicular to the branch.
                            translate(trans_pos)
                                rotate(a = 90, v =[1,0,0])        // 90° rotation about branch axis.
                                // rotate(a = rot_angle1 * (180/PI), v = rot_axis1)  // Align [0,0,1] with branch.
                                cylinder(h = 10, r =  my_tip_size * my_tip_scale, center = true, $fn = 32);
                    }
                }
            }

            // Check if there are iterations left
            if(iterations_left > 0)
            {
                // Check if there are more than one branch
                if(num_branches > 1)
                {
                    // Check if there are more than 3 iterations left
                    if(iterations_left > 3)
                    {
                        // Check if the branch should extend
                        if(extend_branch == true || extend_branch == 1)
                        {
                            // Draw the vector branch from the polygon with modified parameters
                            draw_vector_branch_from_polygon
                            (
                                direction = my_direction + random_3DVector(my_seed) * .4,
                                root = my_root + my_vector,
                                polygon_bounding_size = polygon_size,
                                twist = my_twist,
                                last_branch_root_scale = my_root_scale * .8,
                                last_branch_length = my_length,
                                iterations_total = _iterations_total,
                                iterations_left = _iterations_left - 1,
                                min_branching = max(0, _iterations_total - current_iteration * 2),
                                max_branching = current_iteration + 2,
                                extend_branch = my_extend_branch
                            )
                                children();
                        }
                    }
                    // Loop through each branch
                    for(i = [0:num_branches - 1])
                    {
                        
                        
                            // Calculate the new branch direction
                            new_branch_direction = rotAxisAngle_3DVector(rotAxisAngle_3DVector(my_direction, random_3DVector(my_seed), new_branches_branching_angle[i]), my_direction, 360 / num_branches * i);
                        
                        
                            // Check if overhangs are allowed
                            if(overhangs_allowed == true || overhangs_allowed == 1)
                            {
                                echo("true");
                                // Draw the vector branch from the polygon with the new branch direction
                                draw_vector_branch_from_polygon
                                (
                                    direction = new_branch_direction,
                                    root = my_root + (my_vector * new_branches_budding_positions[i]),
                                    polygon_bounding_size = polygon_size,
                                    twist = my_twist,
                                    last_branch_root_scale = my_root_scale,
                                    last_branch_length = my_length,
                                    iterations_total = _iterations_total,
                                    iterations_left = _iterations_left - 1,
                                    min_branching = max(0, _iterations_total - current_iteration * 2),
                                    max_branching = current_iteration + 2,
                                    overhangs_allowed = true,
                                    extend_branch = my_extend_branch
                                )
                                    children();
                            }
                            else
                            {
                                // Check if the branching angle is within the allowed overhang angle
                                if(angleBetween_3DVector(new_branch_direction, [0,0,1]) < overhang_angle_cutoff)
                                {
                                    // Draw the vector branch from the polygon with the new branch direction
                                    draw_vector_branch_from_polygon
                                    (
                                        direction = new_branch_direction,
                                        root = my_root + (my_vector * new_branches_budding_positions[i]),
                                        polygon_bounding_size = polygon_size,
                                        twist = my_twist,
                                        last_branch_root_scale = my_root_scale,
                                        last_branch_length = my_length,
                                        iterations_total = _iterations_total,
                                        iterations_left = _iterations_left - 1,
                                        min_branching = max(0, _iterations_total - current_iteration * 2),
                                        max_branching = current_iteration + 2,
                                        overhangs_allowed = false,
                                        extend_branch = my_extend_branch
                                    )
                                        children();
                                }
                                else
                                {
                                    
                                    
                                        // Correct the branch direction to ensure proper overhang
                                        corrected_branch_direction = rotAxisAngle_3DVector
                                        (
                                            trackTo_3DVector
                                            (
                                                new_branch_direction,
                                                [0,0,1],
                                                abs
                                                (
                                                    rands(overhang_angle_cutoff - 10, overhang_angle_cutoff, 1, my_seed)[0] - angleBetween_3DVector(new_branch_direction, [0,0,1])
                                                ) / angleBetween_3DVector(new_branch_direction, [0,0,1])
                                            ),
                                            [0,0,1],
                                            rands(-30, 30, 1, my_seed)[0]
                                        );
                                    
                                    
                                        // Draw the vector branch from the polygon with the corrected branch direction
                                        draw_vector_branch_from_polygon
                                        (
                                            direction = corrected_branch_direction,
                                            root = my_root + (my_vector * new_branches_budding_positions[i]),
                                            polygon_bounding_size = polygon_size,
                                            twist = my_twist,
                                            last_branch_root_scale = my_root_scale,
                                            last_branch_length = my_length,
                                            iterations_total = _iterations_total,
                                            iterations_left = _iterations_left - 1,
                                            min_branching = max(0, _iterations_total - current_iteration * 2),
                                            max_branching = current_iteration + 2,
                                            overhangs_allowed = false
                                        )
                                            children();
                                    
                                }
                            }
                        
                    }
                }
            }
        }
    }
    else
    {
        // Display an error message if the polygon bounding size is not defined
        if(polygon_bounding_size == undef)
        {
            assert(false,"You have to provide a bounding size of the polygon due to limitations of OpenSCAD");
        }
    }
}

// linear extrude with a polygon to create a 3D shape
// This module draws a capped vector from a polygon, which is used to create the branches of the tree
// It takes a vector, root point, scale factor for the tip, color based on magnitude, and twist angle as parameters
// It calculates the length and angles of the vector, rotates it into place, and extrudes the polygon along the vector's length
// If iterations_left is 0, it draws a rounded cap (sphere) at the tip of the vector
// The function uses the magnitude of the vector to determine its color and scale
module draw_capped_vector_from_polygon
(
    vector = [10, 10, 10], // The vector direction and length
    root = [0, 0, 0], // The starting point of the vector
    scale_tip = .5, // The scale factor for the tip of the vector
    color_from_magnatude = true, // Whether to color the vector based on its magnitude
    magnatude_range = 100, // The range of magnitudes for coloring
    twist_poly = 0, // The twist angle for the polygon
	iterations_left = -1, // the number of iters left, to determine if we need to draw a cap
    cap_size = -1 // the size of the cap to draw at the end of the vector
)
{
    // Calculate the length of the vector in the XY plane
    xyLength = sqrt(pow(vector[0], 2) + pow(vector[1], 2));
    
    // Calculate the magnitude of the vector
    magnatude = abs(sqrt(pow(vector[0], 2) + pow(vector[1], 2) + pow(vector[2], 2)));
    
    // Calculate the angle in the Z plane
    zAngle = xyLength == 0 ? vector[0] > 0 ? 90 : -90 : acos(vector[1] / xyLength);
    
    // Calculate the angle in the X plane
    xAngle = acos(xyLength / magnatude);
    
    // Determine the real X angle based on the Z component of the vector
    realxAngle = vector[2] > 0 ? xAngle : -xAngle;
    
    // Determine the real Z angle based on the X component of the vector
    realzAngle = vector[0] > 0 ? -zAngle : zAngle;
    
    // Store the rotation angles in a vector
    vecRot = [realxAngle,realzAngle];
    
    // Move the vector to start at the root location
    translate(root)
    
    // Use the vector's magnitude compared to the magnitude range to determine its color
    color(hsvToRGB(magnatude / magnatude_range * 360,1,1,1))
        // Start with the vector pointing along the Y axis and then rotate it into place
        rotate([0, 0, vecRot[1]])
        {
            rotate([vecRot[0], 0, 0])
            {
                rotate([-90, 0, 0])
                {
                    // Extrude the polygon along the vector's length with the specified scale and twist
                    linear_extrude(height = magnatude, scale = scale_tip, twist = twist_poly)
                    children();
                    
					// if we're on a terminal branch, draw a cap
					if (iterations_left == 0){
						// Translate to the tip of the vector and add a rounded cap (sphere)
        	            translate([0,0,magnatude])
           		        sphere(r = cap_size[0] / 2, center = true, $fn = 32);
					}
                    
                }
            }
        }
}

// Function to calculate the magnitude of a 3D vector
function magnatude_3DVector(v) = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);

// Function to calculate the angle between two 3D vectors
function angleBetween_3DVector(u, v) = acos((u * v) / (magnatude_3DVector(u) * magnatude_3DVector(v)));

// Function to normalize a 3D vector
function normalize_3DVector(v) = [v[0]/magnatude_3DVector(v), v[1]/magnatude_3DVector(v), v[2]/magnatude_3DVector(v)];

// Function to calculate the dot product of two 3D vectors
function dotProduct_3DVector(u, v) = u * v;

// Function to calculate the cross product of two 3D vectors
function crossProduct_3DVector(u, v) = [u[1]*v[2] - v[1]*u[2], u[2]*v[0] - v[2]*u[0], u[0]*v[1] - v[0]*u[1]]; 
    
// Function to create a rotation matrix for a 3D vector
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

// Function to rotate a 3D vector around an axis by a given angle
function rotAxisAngle_3DVector(vec, axis, angle) = rotMatrix_3DVector(normalize_3DVector(axis), angle) * vec;

// Function to track a 3D vector to a target vector with a given influence
function trackTo_3DVector(cur, tar, influence) = rotAxisAngle_3DVector(cur, crossProduct_3DVector(cur, tar), angleBetween_3DVector(cur, tar) * influence);

// Function to generate a random 3D vector
function random_3DVector(seed = undef) =	[
                                                seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed - 100)[0])[0],
                                                seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed)[0])[0],
                                                seed == undef ? rands(0, 1, 1)[0] : rands(0, 1, 1, rands(0, 10000, 1, seed + 100)[0])[0]
                                            ];
                                        
// Function to reduce the number of points in a shape to a specified number
function shape_reducer(shape, reduce_to, index) = floor(len(shape[0]) / reduce_to) * index;

// Function to reduce a shape to 32 points
function reduce_shape_to_32_points(shape) =	[
                                                [
                                                    [shape[0][shape_reducer(shape, 32, 0)][0], shape[0][shape_reducer(shape, 32, 0)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 1)][0], shape[0][shape_reducer(shape, 32, 1)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 2)][0], shape[0][shape_reducer(shape, 32, 2)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 3)][0], shape[0][shape_reducer(shape, 32, 3)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 4)][0], shape[0][shape_reducer(shape, 32, 4)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 5)][0], shape[0][shape_reducer(shape, 32, 5)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 6)][0], shape[0][shape_reducer(shape, 32, 6)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 7)][0], shape[0][shape_reducer(shape, 32, 7)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 8)][0], shape[0][shape_reducer(shape, 32, 8)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 9)][0], shape[0][shape_reducer(shape, 32, 9)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 10)][0], shape[0][shape_reducer(shape, 32, 10)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 11)][0], shape[0][shape_reducer(shape, 32, 11)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 12)][0], shape[0][shape_reducer(shape, 32, 12)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 13)][0], shape[0][shape_reducer(shape, 32, 13)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 14)][0], shape[0][shape_reducer(shape, 32, 14)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 15)][0], shape[0][shape_reducer(shape, 32, 15)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 16)][0], shape[0][shape_reducer(shape, 32, 16)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 17)][0], shape[0][shape_reducer(shape, 32, 17)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 18)][0], shape[0][shape_reducer(shape, 32, 18)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 19)][0], shape[0][shape_reducer(shape, 32, 19)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 20)][0], shape[0][shape_reducer(shape, 32, 20)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 21)][0], shape[0][shape_reducer(shape, 32, 21)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 22)][0], shape[0][shape_reducer(shape, 32, 22)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 23)][0], shape[0][shape_reducer(shape, 32, 23)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 24)][0], shape[0][shape_reducer(shape, 32, 24)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 25)][0], shape[0][shape_reducer(shape, 32, 25)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 26)][0], shape[0][shape_reducer(shape, 32, 26)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 27)][0], shape[0][shape_reducer(shape, 32, 27)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 28)][0], shape[0][shape_reducer(shape, 32, 28)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 29)][0], shape[0][shape_reducer(shape, 32, 29)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 30)][0], shape[0][shape_reducer(shape, 32, 30)][1]],
                                                    [shape[0][shape_reducer(shape, 32, 31)][0], shape[0][shape_reducer(shape, 32, 31)][1]]
                                                ],
                                                [
                                                    [
                                                        0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
                                                    ]
                                                ]
                                            ];