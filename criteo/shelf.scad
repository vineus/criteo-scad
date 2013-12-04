length = 250;
height = 90;
padding = 10;
width = 35;
thickness = 2;

branch_width = 10;

pad_r = 25;
pad_num = 1;

module drawHalfPlate() {
	union() {
		translate([0, padding])
			cube([length, width, thickness]);
	
		translate([length / 3 - branch_width / 2, padding, 0]) {
			translate([0, -padding, height - thickness])
				cube([branch_width, padding, thickness]);
			cube([branch_width, thickness, height]);
		
			translate([- branch_width, 0, 0])
				cube([branch_width * 3, thickness, height / 5]);
		}
		
		translate([length * 2 / 3 - branch_width / 2, padding, 0]) {
			translate([0, -padding, height - thickness])
				cube([branch_width, padding, thickness]);
			cube([branch_width, thickness, height]);
	
			translate([- branch_width, 0, 0])
				cube([branch_width * 3, thickness, height / 5]);
		}
	}
}

module drawHalf() {
	x_delta = length / pad_num;

	difference() {
		union() {
			for (i = [0:pad_num]) {
				translate([i * x_delta, width + padding, 0.25])
					cylinder(0.5, pad_r, pad_r, true);

				//translate([i * x_delta, padding, 0.5])
				//	cylinder(1, pad_r, pad_r, true);
			}
		}

		drawHalfPlate();
	}

	drawHalfPlate();
}

union() {
	drawHalf();
	mirror([0, width, 0]) {
		drawHalf();
	}
}