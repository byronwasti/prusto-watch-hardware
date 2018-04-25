use <util.scad>
use <components.scad>

$fn = 10;

/* Module Definitions */

module bottom_frame(r, h, wt=1) {
    translate([0, 0, h/2])
    union() {
        linear_extrude(height=h) {
            projection(cut=true) {
                translate([0, 0, 0.1])
                    hollowed_octagon(r, h, wt);
            }
        }

        difference() {
            hollowed_octagon(r, h, wt);
            translate([-r, -r, 0]) cube([r*2, r*2, h*5]);
        }   
    }
}

module bottom_clips(r, length, dist) {
    translate([0, -dist, 0])
        rotate([0, 90, 0])
        difference() {
            capped_cylinder(r=r, h=length);
            translate([0, length, 0])
                cube([length*2, length*2, length*2], center=true); 
        }

    translate([0, dist, 0])
        rotate([0, 90, 0])
        difference() {
            capped_cylinder(r=r, h=length);
            translate([0, -length, 0])
                cube([length*2, length*2, length*2], center=true); 
        }
}

module bottom_harness() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            hull() {
                translate([j*6, i*21, 3])
                    rotate([i*45, 0, 0])
                    cylinder(r=1, h=6, center=true);

                translate([j*6, i*21, 1])
                    rotate([90, 0, 0])
                    cylinder(r=1, h=6, center=true);
            }
        }

        translate([0, i*24, 1])   
            rotate([0, 90, 0])
            cylinder(r=1, h=13, center=true);
    }

}

// Radius, height, wallthickness
module bottom(r, h, wt=1) {
    bottom_harness();
        
    difference() {
        union() {
            translate([0, 0, 5])
                bottom_clips(2, 12, cos(22.5) * (r));

            bottom_frame(r, h, wt);
        }
        translate([0, 0, 5])
           bottom_clips(1, 10, cos(22.5) * (r-1));

        translate([0, 0, 5])
            rotate([90, 0, 0])
            cylinder(r=1, h=r*3, center=true);
    }
}

// Radius height wallthickness
module top(r, h, wt=1) {
    union() {
        translate([0, 0, -h])
        linear_extrude(height=h) {
            projection(cut=true) {
                translate([0, 0, 0.1])
                    hollowed_octagon(r, h, wt);
            }
        }

        difference() {
            hollowed_octagon(r, h, wt);
            translate([0, 0, -(h*5)/2])
                cube([r*2, r*2, h*5], center=true);
            cylinder(r=15, h=10);
        }   
    }
}


/* Global Variables */

radius = 20;
bottom_height = 6;
thickness = 1;


/* Main Objects */

//translate([0, 0, 5]) battery();
//translate([0, 0, 10]) pcb();
translate([0, 0, 15]) display();
!bottom(22, 5);
translate([0, 0, 11]) top(22, 5);
