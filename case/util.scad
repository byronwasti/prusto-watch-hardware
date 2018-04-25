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

module rounded_box(dim, r) {
    minkowski() {
        cube(dim, center=true);
        sphere(r=r);
    }
}

module hollowed_octagon(r, h, wt=1) {
    difference() {
        translate([]) rounded_octagon_2(r, 5);
        rounded_octagon_2(r-wt, 2);
    }
}

module capped_cylinder(r, h) {
    cylinder(r=r, h=(h-2*r), center=true);
    translate([0, 0, -(h-2*r)/2])
        sphere(r=r);
    translate([0, 0, (h-2*r)/2])
        sphere(r=r);
}
