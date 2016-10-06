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
base_height = 50; // Default: 50
base_radius = 10; // Default: 10
perimeter=2;

nose_clip_height = 3; //Default: 3
nose_clip_length = 15; //Default: 15

hinge_outer_diameter = 6; // Default: 6
hinge_inner_diameter = 3; // Default: 3
hinge_length = 20; // Default: 20
hinge_cut_width = 10; // Default: 10

dummy = 0.1; // Default: 0.1
$fn=64; // Default: 64 for preview and 192+ for final render

// Create the main frame
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
            cube([1,40,thickness+dummy], center=true);
        }
    }
}
// nose clip

 translate([15,18,2])
    rotate([0,0,19]){
            cube([nose_clip_length,nose_clip_height,4], center=true);  
            translate([-7.3,0,1.2])rotate([90,0,90])cylinder(d=3.6,nose_clip_length);
            translate([-7.3,0,1.2])sphere(d = 4);
            translate([7.3,0,1.2])sphere(d = 4);
        }
 translate([15,-18,2])
    rotate([0,0,-19]){
            cube([nose_clip_length+dummy,nose_clip_height+dummy,4], center=true);   
            translate([-7.3,0,1.2])rotate([90,0,90])cylinder(d=3.6,nose_clip_length);
            translate([-7.3,0,1.2])sphere(d = 4);
            translate([7.3,0,1.2])sphere(d = 4);
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

