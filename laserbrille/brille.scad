/*
TODO:
 * Proportionen anhand von Variablen setzten
 * besser kommentieren
*/


// define global variables
diameter_glass = 33.5; // Default: 33.5
thickness_glass = 2; // Default: 2
diameter_nose = 18; // Default: 18
thickness = 3; // Default: 3
eye_distance = 64; // Default: 64
base_width = 120; // Default: 120

// define global variables
diameter_glass = 33.5; // Default: 33.5
thickness_glass = 2; // Default: 2
diameter_nose = 18; // Default: 18
thickness = 3; // Default: 3
eye_distance = 64; // Default: 64
base_width = 120; // Default: 120
base_height = 50; // Default: 50
base_radius = 10; // Default: 10
perimeter=2;

nose_clip_height = 3; //Default: 3
nose_clip_length = 15; //Default: 15
nose_clip_base = 40;  //Default: 40
round_end = 3;      //Default: 3.6


hinge_outer_diameter = 6; // Default: 6
hinge_inner_diameter = 3; // Default: 3
hinge_length = 20; // Default: 20
hinge_cut_width = 10; // Default: 1

side_ear_radius = 20;

dummy = 0.1; // Default: 0.1
$fn=64; // Default: 64 for preview and 192+ for final render
module roundedRect(size, radius)
{
	x = size[0];
	y = size[1];
	z = size[2];

	linear_extrude(height=z)
	hull()
	{
		// place 4 circles in the corners, with the given radius
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
		circle(r=radius);
	
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
		circle(r=radius);
	}
}

// Create the main frame
module main_frame() {
	difference(){
		// Create the base cuboid
		//cube([50,120,thickness],center=true);
		hull(){
			for(x=[-base_height/2+base_radius,base_height/2-base_radius], y=[-base_width/2+base_radius, base_width/2-base_radius]){  
				translate([x,y,0]){
					// Create the dummy cylinder,
					cylinder(r=base_radius,h=thickness,center=true);    
				}
			}
		}

		// Create cylinder, which is the glass after the print
		// To move it appart by half the eye distance
		for(y=[-eye_distance/2, eye_distance/2]){
			translate([0,y,0]){
				// Create the dummy glasses, which will be removed later
				translate([0,0,thickness/2-thickness_glass])
					cylinder(d=diameter_glass, h=thickness_glass+dummy);
				// Cut out the rest
					cylinder(d=diameter_glass-perimeter, h=thickness+dummy, center=true);
			}
		}

		// Create a space for nose
		hull(){
			translate([-5,0,0]){
				cylinder(d=diameter_nose, h=thickness+dummy, center=true);
			}
			translate([25,0,0]){
				cube([1,nose_clip_base,thickness+dummy], center=true);
			}
		}
	}
	// nose clip

	 translate([15,18,2])
		rotate([0,0,19.5]){
				cube([nose_clip_length,nose_clip_height,3], center=true);  
				translate([-7.3,0,1.5])rotate([90,0,90])cylinder(d=3,nose_clip_length);
				translate([-7.3,0,1.5])sphere(d = round_end);
				translate([7.7,0,1.5])sphere(d = round_end);
			}
	 translate([15,-18,2])
		rotate([0,0,-19.5]){
				cube([nose_clip_length+dummy,nose_clip_height,3], center=true);   
				translate([-7.3,0,1.5])rotate([90,0,90])cylinder(d=3,nose_clip_length);
				translate([-7.3,0,1.5])sphere(d = round_end);
				translate([7.7,0,1.5])sphere(d = round_end);
		}
	// Hinge

	for(y=[-base_width/2+hinge_outer_diameter/2, base_width/2-hinge_outer_diameter/2]) {
		translate([-hinge_length/2,y,thickness/2+hinge_outer_diameter/2]) rotate([0,90,0]) difference() {
			union() {
				cylinder(d=hinge_outer_diameter, h=hinge_length);
				translate([0,-hinge_outer_diameter/2,0]) cube([hinge_outer_diameter/2,hinge_outer_diameter,hinge_length]);
			}
			translate([0,0,-dummy]) cylinder(d=hinge_inner_diameter, h=hinge_length+2*dummy);
			translate([0,0,hinge_length/2])
				cube([hinge_outer_diameter+dummy,hinge_outer_diameter+dummy,hinge_cut_width], center=true);
		}
	}
}

module side_front() {
	difference(){
		translate([40,0,2]){
			minkowski() {
				cube([13,100,.1], center=true);
				rotate([90,0,0]) cylinder(d=2.9);
			}
			rotate([0,90,0]) {
				difference() {
					union() {
						translate([-4.5,-47,-5]){
							cylinder(d=hinge_outer_diameter, h=hinge_cut_width-0.2);
							translate([0,-hinge_outer_diameter/2,0]) cube([hinge_outer_diameter/2,hinge_outer_diameter,hinge_length/2]);
						}
					}
					translate([-4.5,-47,-5.5]) cylinder(d=hinge_inner_diameter, h=hinge_length/2+1); 
				}
			}
		}
		hull(){
				translate([40,-40,-0]) cylinder(d=3, h=3+1); 
				translate([40,-10,-0]) cylinder(d=3, h=3+1);
		}
		hull(){
				translate([40,40,-0]) cylinder(d=3, h=3+1); 
				translate([40,10,-0]) cylinder(d=3, h=3+1);
		}
	}
}

module side_rear() {
	translate([60,-15,2]){
		minkowski() {
			cube([13,70,.1], center=true);
			rotate([90,0,0]) cylinder(d=2.9);
		}
	}
	translate([60+side_ear_radius+12.9/2,20,2]) intersection() {
		rotate_extrude() {
			hull() {
				translate([side_ear_radius,0,0]) circle(d=3);
				translate([side_ear_radius+12.9,0,0]) circle(d=3);
			}
		}
		translate([-100/2,0,-100/2]) cube([100,100,100]);
	}
	hull(){
			translate([60,-45,-0]) cylinder(d=2.9, h=6); 
			translate([60,-35,-0]) cylinder(d=2.9, h=6);
	}
	hull(){
			translate([60,5,-0]) cylinder(d=2.9, h=6); 
			translate([60,15,-0]) cylinder(d=2.9, h=6);
	}
}

main_frame();
for(a=[0,180]) rotate([0,0,a]) side_front();
for(a=[0,180]) rotate([0,0,a]) side_rear();

