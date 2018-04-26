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
                    rounded_octagon_2(r, h);
            }
        }

        difference() {
            rounded_octagon_2(r, h);
            translate([-r, -r, 0]) cube([r*2, r*2, h*5]);
        }   
    }
}

module bottom_frame_cutout(r, h, wt=1) {
    translate([0, 0, h/2])
    union() {
        linear_extrude(height=h) {
            projection(cut=true) {
                translate([0, 0, 0.1])
                    rounded_octagon_2(r-wt, h);
            }
        }

        difference() {
            rounded_octagon_2(r-wt, h);
            translate([-r, -r, 0]) cube([r*2, r*2, h*5]);
        }   
    }
}

module bottom_usb_cutout(w=4, h=3) {
    difference() {
        cube([10, 7, 3], center=true);
        translate([0, -6, 3]) rotate([45, 0, 0]) cube([11, 10, 8], center=true);
        translate([0, 6, 3]) rotate([-45, 0, 0]) cube([11, 10, 8], center=true);
    }
}

module bottom_clips(r, length, dist) {
    for(i = [45, -45, 180]) {
        rotate([0, 0, i])
            translate([0, dist, 0])
            rotate([0, 90, 0])
            difference() {
                //capped_cylinder(r=r, h=length);
                cylinder(r=r, h=length, center=true);
                translate([0, -length, 0])
                    cube([length*2, length*2, length*2], center=true); 
            }
    }
}

module bottom_harness() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            hull() {
                translate([j*6, i*21, 4])
                    rotate([i*45, 0, 0])
                    cylinder(r=1, h=8, center=true);

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
        
    difference() {
        union() {
            translate([0, 0, 5])
                bottom_clips(2, 12, cos(22.5) * (r));

            bottom_harness();
            bottom_frame(r, h, wt);
        }

        translate([0, 0, 5])
           bottom_clips(1, 10, cos(22.5) * (r-1));

        translate([0, 0, 1]) bottom_frame_cutout(r, h, wt);
        
        translate([-20, -3, 5]) bottom_usb_cutout();

        // Jtag cutout
        translate([-15, -15, 3]) rotate([0, 0, 45]) cube([6, 6, 3], center=true);
    }
}

module top_clips(r, length, dist) {
    for(i = [45, -45, 180]) {
        rotate([0, 0, i])
        translate([0, dist, 0])
            difference() {
                translate([0, 0, 1])
                cube([8, 2, 6], center = true);

                translate([0, -3, 8])
                    rotate([30, 0, 0])
                    cube([10, 10, 10], center=true);

                translate([0, 1, 0])
                    rotate([0, 90, 0])  
                    cylinder(r = 1.3, h = 10, center=true);
            }
    }
}


// Radius height wallthickness
module top(r, h, wt=1) {
    union() {
        translate([0, 0, -4])
            top_clips(2, 12, cos(22.5) * 21);

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
            cylinder(r=27/2, h=10);
        }   
    }
}

module half_cut() {
    difference() {
        union() {
            translate([0, 0, 11]) top(22, 3);
            translate([0, 0, 0])bottom(22, 5);
        }

        translate([0, -25, 0]) cube([50, 50, 50]);
    }
}

module side_by_side() {
    $fn=40;
    union() {
        bottom(22, 5);
        translate([0, 50, 2.5]) rotate([0, 180, 0]) top(22, 3);
    }
}


/* Global Variables */

radius = 20;
bottom_height = 6;
thickness = 1;


/* Main Objects */

//translate([0, 0, 5]) battery();
//translate([0, 0, 10]) pcb();
translate([0, 0, 0]) rotate([0, 0, 180]) display();
translate([0, 0, 15]) top(22, 3);
translate([0, 0, -15])bottom(22, 5);

//!half_cut();

!side_by_side();


