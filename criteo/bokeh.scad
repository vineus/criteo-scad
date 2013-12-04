supports = true;
epsilon = 0.1;

ring_inner_r = 37.1;
ring_thickness = 3;
ring_height = 8;

blocker_height = 1.5;
blocker_width = 14;
blocker_length = 1.2;
blocker_pad = 8;
blocker_pad_rot = asin(blocker_pad / 2 / ring_inner_r);
blocker_rot = blocker_pad_rot + asin(blocker_width / 4 / ring_inner_r) * 2;
blocker_big_width = 5;
blocker_big_length = 1.6;
blocker_big_rot = - blocker_pad_rot + 2 * blocker_rot + asin(blocker_big_width / 4 / ring_inner_r) * 2;
blocker_triangle_rot = blocker_big_rot + asin(blocker_big_width / 4 / ring_inner_r) * 2 + asin(4 / 4 / ring_inner_r) * 2;

holder_height = 1.5;
holder_thickness = 0.8;
holder_length = 2.1;
holder_width = 20;
bokey_height = 1;
bokey_r = ring_inner_r + ring_thickness - holder_thickness - 0.2;

module ring() {
	difference() {
		cylinder(ring_height, ring_inner_r + ring_thickness, ring_inner_r + ring_thickness);
		cylinder(ring_height, ring_inner_r, ring_inner_r);
	}
}

module ring_blocker_outer() {
	difference() {
		cylinder(blocker_height, ring_inner_r, ring_inner_r);
		cylinder(blocker_height, ring_inner_r - blocker_length, ring_inner_r - blocker_length);
	}	
}


module ring_blocker_inner() {
	difference() {
		cylinder(blocker_height, ring_inner_r, ring_inner_r);
		cylinder(blocker_height, ring_inner_r - blocker_big_length, ring_inner_r - blocker_big_length);
	}	
}

module ring_holder_lower() {
	translate([0, 0, ring_height]) {
		difference() {
			cylinder(holder_height, ring_inner_r + holder_thickness + holder_length, ring_inner_r + holder_thickness + holder_length);
			cylinder(holder_height, ring_inner_r + holder_length, ring_inner_r + holder_length);
		}	
	}
}

module ring_holder_upper() {
	translate([0, 0, ring_height + holder_height]) {
		difference() {
			cylinder(holder_height, ring_inner_r + holder_thickness + holder_length, ring_inner_r + holder_thickness + holder_length);
			cylinder(holder_height, ring_inner_r, ring_inner_r);
		}	
	}
}

module blockers_outer() {
	rotate([0, 0, blocker_rot]) {
		translate([ring_inner_r, 0, 0]) {
			cube([20, blocker_width, 100], true);
		}
	}
	rotate([0, 0, -blocker_rot]) {
		translate([ring_inner_r, 0, 0]) {
			cube([20, blocker_width, 100], true);
		}
	}
	
	rotate([0, 0, -blocker_triangle_rot]) {
		translate([ring_inner_r, 0, 0]) {
			linear_extrude(blocker_height) {
				polygon([
					[0, 0],
					[-1, -0.5],
					[0, -2.5]
				]);
			}
		}
	}
}

module blockers_inner() {
	rotate([0, 0, blocker_big_rot]) {
		translate([ring_inner_r, 0, 0]) {
			cube([20, blocker_big_width, 100], true);
		}
	}

	rotate([0, 0, -blocker_big_rot]) {
		translate([ring_inner_r, 0, 0]) {
			cube([20, blocker_big_width, 100], true);
		}
	}
}

module half_blockers() {
	intersection() {
		ring_blocker_inner();
		blockers_inner();
	}
	
	intersection() {
		ring_blocker_outer();
		blockers_outer();
	}
}

module holder() {
	intersection() {
		ring_holder_lower();
		translate([ring_inner_r, 0, ring_height + holder_height / 2]) {
			cube([20, holder_width, holder_height], true);
		}
	}

	intersection() {
		ring_holder_upper();
		translate([ring_inner_r, 0, ring_height + holder_height + holder_thickness / 2]) {
			cube([20, holder_width, holder_thickness], true);
		}
	}

	if (supports) {
		intersection() {
			translate([0, 0, ring_height + epsilon]) {
				difference() {
					cylinder(holder_height - 2 * epsilon, ring_inner_r + epsilon, ring_inner_r + epsilon);
					cylinder(holder_height - 2 * epsilon, ring_inner_r, ring_inner_r);
				}	
			}
			translate([ring_inner_r, 0, ring_height + holder_height / 2]) {
				cube([20, holder_width, holder_height], true);
			}
		}
	}
}

$fn=100;

module boke_support() {
	ring();
	half_blockers();
	rotate([0, 0, 180])
		half_blockers();
	
	holder();
	rotate([0, 0, 180])
		holder();
}

module boke() {
	cylinder(bokey_height, bokey_r, bokey_r);	
}

module sym_mickey() {
	mickey_r = 5;
	cylinder(10, mickey_r * 1.5, mickey_r * 1.5);
	rotate([0, 0, -45])
	translate([mickey_r * 2.3, 0, 0])
		cylinder(10, mickey_r, mickey_r);
	rotate([0, 0, 45])
	translate([mickey_r * 2.3, 0, 0])
		cylinder(10, mickey_r, mickey_r);
}

translate([0,0,8.5]) {
difference() {
	boke();
	sym_mickey();
}
}

//boke_support();