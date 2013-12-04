use <C:/Dev/MCAD/boxes.scad>;

module truc1() {
	r = 23.5;
	height = 15;
	thickness = 3;
	
	truc_thickness = 1.5;
	truc_z_pad = 1;

	module ring() {
		// Ring
		difference() {
			cylinder(height, r+thickness, r+thickness);
			translate([0,0,2])cylinder(height, r, r);
		}
	}
	
	module truc() {
		translate([-7.5, 10, 0]) {
			rotate([90, 0, 0])
				linear_extrude(20) {
					polygon([
						[0, 0],
						[15, 0],
						[15, -1.8],
						[2, -3],
						[2, -5],
						[0, -5]
					]);
				}
		}
	}
	
	module trucs() {
		translate([0, r, height - truc_z_pad]) {
			truc();
		}
		
		rotate([0, 0, 120]) {
			translate([0, r, height - truc_z_pad]) {
				truc();
			}
		}
		
		rotate([0, 0, 240]) {
			translate([0, r, height - truc_z_pad]) {
				truc();
			}
		}
	}
	
	ring();
	
	intersection() {
		trucs();
		difference() {
			cylinder(height, r, r);
			cylinder(height, r-truc_thickness, r-truc_thickness); 
		}
	}
}


module truc2() {
	r = 21.45;
	r2_x_pad = 9;
	r2_z_pad = 4.5;

	thickness = 1.75;
	height = 13;
	epsilon = 0.001;

	module ring() {
		difference() {
			union() {
				cylinder(height - r2_z_pad, r + r2_x_pad, r + r2_x_pad);
				cylinder(height, r, r);
			}
			translate([0, 0, thickness])
				cylinder(height, r-thickness, r-thickness);
		}
	}

	module truc() {
		intersection() {
			translate([r - thickness, 0, height]) {
				rotate([180, 0, -90]) {
					translate([-10, -5, 0]) {
						cube([20, 10, 1.2]);
						cube([2, 10, r2_z_pad]);
					}
				}
			}

			difference() {
				cylinder(height, r+thickness, r+thickness); 
				cylinder(height, r, r);
			}
		}

		intersection() {
			translate([r - thickness, 0, height]) {
				rotate([180, 0, -90]) {
					translate([-6, -5, epsilon + 1.2]) {
						cube([16, 10, r2_z_pad-1.2-epsilon*2]);
					}
				}
			}

			translate([r - thickness, 0, height]) {
				rotate([180, 0, -90]) {
					translate([-6, -5, epsilon + 1.2]) {
						cube([16, 10, r2_z_pad-1.2-epsilon*2]);
					}
				}
			}

			union() {
				difference() {
					cylinder(height, r+thickness/2, r+thickness/2); 
					cylinder(height, r+thickness/2-epsilon, r+thickness/2-epsilon);
				}
				difference() {
					cylinder(height, r+thickness, r+thickness); 
					cylinder(height, r+thickness-epsilon, r+thickness-epsilon);
				}
			}
		}
	}

	module trucs() {
		truc();
		
		rotate([0, 0, 120]) {
			truc();
		}
		
		rotate([0, 0, 240]) {
			truc();
		}
	}

	module blocker() {
		sa = 19.8;
		ca = 17.91;
		h = height - r2_z_pad - 2;
		r = 1.25;

		rotate([0, 0, acos(ca / 26.6)]) {
			translate([sqrt(sa * sa + ca * ca), 0, h]) {
				translate([r/2, 0, 0])
					cylinder(2, r, r);
				translate([-r/2, 0, 0])
					cylinder(2, r, r);
				translate([-r/2, -r, 0])
					cube([r, 2*r, 2]);
			}
		}		
	}

	difference() {
		ring();	
		blocker();
	}
	trucs();
}



$fn = 100;
truc2();