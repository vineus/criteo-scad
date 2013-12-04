use <Write.scad>
module criteo(height = 2)
{
	linear_extrude(height)
	{
	circle(1, center = true);
	translate([11,0,0])
	{
		square([18,1], center = true);
		translate([9,0,0])
		{
			circle(0.5, center = true);
			translate ([0,-4])
			{
				square([1,8], center = true);
				translate([0, -4])
				{
					circle(0.5, center = true);
					translate([3,0])
					{
						square([6,1], center = true);
						translate([5,0]) circle(1, center = true);
					}
				}
			}
		}
	}
	}
	difference()
	{
	translate([-12, -8.5, 0]) write("criteo",t=height,h=7, font = "orbitron.dxf");
	translate([-0.6,-2, -1]) cube([1.2,1.2,height+2]);
	}
}
