include<../lib/threads.scad>

supports = true;
epsilon = 0.1;

ring_outer_r = 26;
ring_inner_r = 23;
ring_thickness = 3;
ring_height = 5;
ring_threaded_height = 3;
ring_extra_thickness = 2;

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
		union() {
			metric_thread(ring_outer_r * 2, 1, ring_threaded_height, internal=false);
			translate([0, 0, ring_threaded_height])
				cylinder(ring_height - ring_threaded_height, ring_outer_r + ring_extra_thickness, ring_outer_r + ring_extra_thickness);
		}
		cylinder(ring_height, ring_inner_r, ring_inner_r);
	}

	if (supports) {
		for (r = [ring_outer_r + ring_extra_thickness : 1 : ring_outer_r+1]) {
			difference() {
				cylinder(ring_threaded_height - epsilon, r, r);
				cylinder(ring_threaded_height - epsilon, r - epsilon, r - epsilon);
			}
		}
	}
}

module ring_holder_lower() {
	translate([0, 0, ring_height]) {
		difference() {
			cylinder(holder_height, ring_outer_r + ring_extra_thickness, ring_outer_r + ring_extra_thickness);
			cylinder(holder_height, ring_inner_r + holder_length, ring_inner_r + holder_length);
		}	
	}
}

module ring_holder_upper() {
	translate([0, 0, ring_height + holder_height]) {
		difference() {
			cylinder(holder_height, ring_outer_r + ring_extra_thickness, ring_outer_r + ring_extra_thickness);
			cylinder(holder_height, ring_inner_r, ring_inner_r);
		}	
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

		intersection() {
			translate([0, 0, ring_height + epsilon]) {
				difference() {
					cylinder(holder_height - 2 * epsilon, ring_inner_r + 1 + epsilon, ring_inner_r + 1 + epsilon);
					cylinder(holder_height - 2 * epsilon, ring_inner_r + 1, ring_inner_r + 1);
				}	
			}
			translate([ring_inner_r, 0, ring_height + holder_height / 2]) {
				cube([20, holder_width + 1, holder_height], true);
			}
		}
	}
}

$fn=100;

module boke_support() {
	ring();
	
	holder();
	rotate([0, 0, 180])
		holder();
}

module boke() {
	cylinder(bokey_height, bokey_r, bokey_r);	
}

module sym_mickey() {
	mickey_r = 2;
	cylinder(10, mickey_r * 1.5, mickey_r * 1.5);
	rotate([0, 0, -45])
	translate([mickey_r * 2.3, 0, 0])
		cylinder(10, mickey_r, mickey_r);
	rotate([0, 0, 45])
	translate([mickey_r * 2.3, 0, 0])
		cylinder(10, mickey_r, mickey_r);
}

translate([0,0,ring_height+0.25]) {
	difference() {
		boke();
		sym_mickey();
	}
}

//boke_support();