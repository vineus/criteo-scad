module notch(size = 10)
{
	linear_extrude(height=10)
	{
		for (i = [0:size])
		{
			translate([i * 32, 0, 0])
			{
				difference()
				{
					square([32, 8]);
					translate([8, 2]) circle(4);
				}
				translate([24, -2]) circle(4);
				translate([0, 8]) square([32,150]);
			}
		}
	}
}

module build(side = 0)
{
	difference()
	{
		import("top.stl");
		rotate([0,0,50]) translate([-124, 30])
		{
			if (side > 0)
				translate([0,0,-2]) notch(10);
			else
				color("green") rotate([180,0,0]) translate([16,0,-8]) notch(7);
		}
	
	}
	color("green")
	{
		if (side > 0)
		{
			translate([40,90]) cylinder(0.25, 15, 15);
			translate([100,0]) cylinder(0.25, 15, 15);
			translate([50,-85]) cylinder(0.25, 15, 15);
			translate([-50,-85]) cylinder(0.25, 15, 15);
			//translate([-80,-40]) cylinder(0.25, 15, 15);
		}
		else
		{
			translate([30,90]) cylinder(0.25, 15, 15);
			translate([-50,90]) cylinder(0.25, 15, 15);
			translate([-100,0]) cylinder(0.25, 15, 15);
			translate([-75,-45]) cylinder(0.25, 15, 15);
		}
	}
}

//notch(0);

build(1);
//build(0);
