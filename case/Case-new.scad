$fn = 10;

/* Module Definitions */

module rounded_hex(r, h) {
    rotate([0, 0, 22.5])
    hull(){
        for (i=[0:8]) {
            rotate([0, 0, i*45])
            translate([r, 0, 0])
                cylinder(h=h, r=3, center=true);
        }
    }
}

// radius, height, corner-radius
module rounded_octagon(r, h, cr) {
    rotate([0, 0, 22.5])
    hull(){
        for (i=[0:7]) {
            rotate([0, 0, i*45])
            translate([(r - cr), 0, 0])
                cylinder(h=h, r=cr, center=true);
        }
    }
}

// radius, height
module rounded_octagon_2(r, h) {
    hull() {
        for (i=[0:7]) {
            rotate([0, 0, i*45])
                translate([cos(22.5) * (r-h/2), 0, 0])
                rotate([90, 0, 0])
                cylinder(h = 2 * (r - h/2) * cos(67.5),
                        r = h / 2,
                        center = true);
        }
    }
}

// radius, height, wall-thickness
module bottom_shell(r, h, t) {
    difference() {
        rounded_hex(r, h)

        translate([-50, -50, 0])
        cube([100, 100, 10]);

        translate([0, 0, 1])
        rounded_hex(r - t, h);
    }
}

module pcb() {
    difference() {
        rounded_hex(17, 2);
        translate([2, -19, 0]) cube([10, 4, 10], center=true);
    }
}

module battery() {
    color([1, 0, 1, 1])
    cylinder(h=3.4, r=15, center=true);
}


module display() {
    color([1, 0, 0, 1])
    translate([-16.5, 16, 0])
    import("display.stl");
}

module rounded_box(dim, r) {
    minkowski() {
        cube(dim, center=true);
        sphere(r=r);
    }
}

module hollowed_octagon(r, h, wt=1) {
    difference() {
        translate([]) rounded_octagon_2(r, 5);
        rounded_octagon_2(r-wt, 2, 3);
    }
}

module capped_cylinder(r, h) {
    cylinder(r=r, h=(h-2*r), center=true);
    translate([0, 0, -(h-2*r)/2])
        sphere(r=r);
    translate([0, 0, (h-2*r)/2])
        sphere(r=r);
}

// Radius, height, wallthickness
module bottom(r, h, wt=1) {

    translate([0, -20, 3])
        rotate([0, 90, 0])
        difference() {
            capped_cylinder(r=2, h=12);
            translate([0, 10, ])
                cube([20, 20, 20], center=true); 
        }

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

/*
difference() {
    translate([0, 0, -1]) bottom_shell(radius, bottom_height, thickness);
    translate([0, -20, 0]) cube([50, 10, 50], center=true);
}
*/


//translate([0, 0, 5]) battery();
//translate([0, 0, 10]) pcb();
translate([0, 0, 15]) display();
!bottom(22, 5);
translate([0, 0, 11]) top(22, 5);
