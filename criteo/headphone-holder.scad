binding_w = 10.8;
binding_h = 6.1;
binding_l = 5;

binding_x_pad = 31.1;
binding_y_pad = 3.6;
binding_z_pad = 0;

binding_thickness = 2;

binding_backplate_height = 42.6;
binding_top_length = 33.8;
binding_arch_length = sqrt(binding_backplate_height * binding_backplate_height + binding_top_length * binding_top_length);
binding_arch_angle = - acos(binding_backplate_height / binding_arch_length);

module desk_binding() {
	module arch() {
		translate([0, 0, -binding_backplate_height-binding_h]) {
			// Back
			cube([binding_w, binding_thickness, binding_backplate_height + binding_h]);

			// Arch
			rotate([binding_arch_angle, 0, 0])
				cube([binding_w, binding_thickness, binding_arch_length]);

			// Front
			translate([0, binding_top_length, 0]) {
				cube([binding_w, binding_thickness, binding_backplate_height]);
			}

			// Bottom
			translate([0, 0, -binding_thickness])
				cube([binding_w, binding_top_length + binding_thickness, binding_thickness]);
		}
	}

	// Left
	translate([binding_x_pad + binding_w, binding_y_pad, binding_z_pad]) {
		cube([binding_w, binding_l, binding_h]);
		translate([0, -binding_y_pad, 0]) {
			cube([binding_w, binding_y_pad, binding_h]);
			
			translate([0, -binding_thickness, binding_h])
				arch();
		}
	}

	// Right
	cube([binding_w, binding_l, binding_h]);
	translate([0, -binding_thickness, binding_h])
		arch();

	// Front
	translate([0, binding_top_length - binding_thickness, -binding_backplate_height-binding_thickness])
		cube([binding_w * 2 + binding_x_pad, binding_thickness, binding_w/2]);
	translate([0, binding_top_length - binding_thickness, -binding_w/2])
		cube([binding_w * 2 + binding_x_pad, binding_thickness, binding_w/2]);
}

holder_width = 50;
holder_r = 50;
holder_block_thickness = 5;
holder_thickness = 3;
holder_angle = 90; 
holder_binding_thickness = 3;
holder_binding_thckness_w = 10;
holder_binding_height = 40;

module holder() {
	module pie_slice(radius, angle, step) {
for(theta = [0:step:angle-step]) {
rotate([0,0,0]) linear_extrude(height = radius*2, center=true)
polygon( points = [[0,0],[radius * cos(theta+step) ,radius * sin(theta+step)],[radius*cos(theta),radius*sin(theta)]]);
}}

module partial_rotate_extrude(angle, radius, axial_range, convex) {
intersection () {
rotate_extrude(convexity=convex) translate([radius,0,0]) child(0);
pie_slice(radius + axial_range, angle, angle/10);
}} 


	translate([0, holder_width/2, 0])
	rotate([90, -holder_angle/2, 0])
	partial_rotate_extrude(angle = holder_angle, radius = holder_r-holder_thickness, axial_range = 255, convex = 10) {
		polygon([
			[holder_thickness/2, holder_width],
			[holder_thickness+holder_block_thickness, holder_width],
			[holder_thickness+holder_block_thickness, holder_width-holder_thickness],		
			[holder_thickness, holder_width-holder_thickness],
			[holder_thickness, holder_thickness],
			[holder_thickness+holder_block_thickness, holder_thickness],
			[holder_thickness+holder_block_thickness, 0],
			[holder_thickness/2, 0],
			[0, holder_thickness/2],
			[0, holder_width - holder_thickness/2],
		]);
	}

	translate([-holder_binding_thckness_w/2, -holder_width/2, holder_r-holder_binding_height-1]) {
		cube([holder_binding_thckness_w, holder_binding_thickness, holder_binding_height]);
		rotate([-45, 0, 0])
			cube([holder_binding_thckness_w, holder_binding_thickness, holder_binding_height * sqrt(2)]);
		rotate([47, 0, 0])
			cube([holder_binding_thckness_w, holder_binding_thickness, holder_binding_height * sqrt(2)]);
	}
}


$fn=100;

desk_binding();
translate([binding_x_pad+binding_w*2+holder_width/2-holder_thickness, binding_top_length/2, -holder_r-binding_backplate_height]) {
	rotate([0, 0, -90]) holder();
}