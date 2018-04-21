$fn = 10;
radius = 20;
thickness = 8;

module rounded_hex(size, height) {
    rotate([0, 0, 22.5])
    hull(){
        for (i=[0:8]) {
            rotate([0, 0, i*45])
            translate([size, 0, 0])
                cylinder(h=height, r=3, center=true);
        }
    }
}

module shell() {
    difference() {
        rounded_hex(radius, thickness)

        translate([-50, -50, 0])
        cube([100, 100, 10]);

        translate([0, 0, 1])
        rounded_hex(radius-1, thickness);
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

//translate([0, 0, -1]) shell();
//translate([0, 0, -2.5]) battery();
projection() translate([0, 0, 1.2]) pcb();
//translate([0, 0, 3]) display();

