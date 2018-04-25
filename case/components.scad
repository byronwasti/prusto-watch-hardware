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

