// nespresso.scad
// Nespresso Coffee Pod Dispenser
// 
// Copyright (C) 2013 Christopher Roberts
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


// General parameters
thickness              =  1.5 ; // thickness of plastic
roundedness            =  0.7 ; // roundedness of boxes between 0 and 1
units                  =  4   ; // number of dispensers wide

// Box parameters
box_width              = 38; // width of box (37.5mm)
box_depth              = 38.5; // depth of box (38.0mm)
box_overhang           = 15.00; // overhang on opening

// Base parameters
base_width             = box_width * 1.20;
base_depth             = box_depth * 2;
base_thickness         = 10;
base_separation        = base_width - (base_width - box_width)/1.4;

// Tube
tube_overhang		  = 0.1;

// Base slope
slope_base			  = box_depth;
slope_height			  = 10;
slope_length			  = sqrt(slope_height * slope_height + slope_base * slope_base);
slope_angle			  = atan(slope_height, slope_base) * 180 / 3.14;

use <C:/Dev/MCAD/boxes.scad>;
use <C:/Dev/MCAD/libtriangles.scad>

module nespresso_base() {

	union() {
    difference() {

        // Things that exist
        union() {

            // flat base
            translate( v = [0, -3, base_thickness - 4] ) {
                roundedBox( [base_width, base_depth - 6, base_thickness], base_width * roundedness /10, true );
            }
            translate( v = [0, 4, base_thickness * 2- 4] ) {
		   		roundedBox( [box_width + thickness * 2, base_depth - 20, base_thickness + 3], base_width * roundedness /10, true );
		   }
        }

        // Things to be cut out
        union() {

            // tray cut-out from flat base
            translate( v = [0, -thickness/3 - 3, base_thickness + 10] ) {
                # roundedBox( [box_width, base_depth - thickness * 2 - 6, base_thickness + 20], box_width * roundedness/10, true );
            }

			translate( v = [0, -15, base_thickness * 2 - 4] )
		      cube([base_width, base_depth, base_thickness + 3], true);
/*
            translate( v = [0, 4, base_thickness * 2- 4] ) {
		   		cube( [box_width - 20, base_depth - 20, base_thickness], true );
		   }
*/

            // make back of cut-out square
           /* translate( v = [0, (base_depth - box_depth - thickness)/-2, base_thickness] ) {
               // cube( size = [box_width, box_depth, base_thickness], center = true );
            }*/


        }
    }

// slope
translate([box_width / 2, - slope_base + 1, base_thickness / 2])
rotate([0, 0, 90])
rightprism(slope_base, box_width, slope_height);

// back steep slope
translate([box_width / 2, - slope_base + 1, base_thickness / 2])
rotate([0, 0, 90])
rightprism(slope_base / 2, box_width, slope_height * 2);

// wall
//translate([0, base_depth / 2 - 10 - thickness * 1.3 / 2, base_thickness + 5])
//roundedBox( [base_width - 10, thickness * 1.3, 10], 1, true );
	}
}

module nespresso_base_tube() {

    difference() {

        // Things that exist
        union() {

            // outside of vertical tube
            translate( v = [0, (base_depth - box_depth - thickness * 2)/-2, base_thickness + box_width] ) {
                roundedBox( [box_width + thickness * 2, box_depth + thickness * 2, box_width * 2], box_width * roundedness/10, true );
            }

        }
       
        // Things to be cut out
        union() {
            
            // inside of vertical tube
            difference() {

                // tube
                translate( v = [0, (base_depth - box_depth - thickness * 2)/-2, base_thickness + box_width] ) {
                    cube( size = [box_width, box_depth, box_width*2], center = true );
                }

                // to stop cardboard tube slipping to the bottom
                union() {
/*
                    // front
                    translate( v = [box_width/2 + tube_overhang, thickness/4, base_thickness + box_width - tube_overhang] ) {
                        rotate( a = [0,90,90] ) {
//                            linear_extrude(height = thickness) polygon( points = [ [0,0], [0,box_width], [box_width, box_width], [box_width,0] ]);
                        }
                    }
*/
                    // back
                    translate( v = [-box_width/2, -box_width + thickness*2 - thickness/2 - tube_overhang, base_thickness - tube_overhang]) {
                        rotate( a = [90,0,0] ) {
                            linear_extrude(height = thickness) polygon( points = [ [0,0], [0,box_width - box_overhang], [box_width, box_width - box_overhang], [box_width,0] ]);
                        }
                    }

                }

            }

            // archway - arch
            translate( v = [0, thickness, base_thickness + box_width/2 + 12.5] ) {
                rotate( a = [90, 0, 0] ) {
                    # cylinder( h = thickness *2 + 1, r = box_width/2, center = true );
                }
            }

            // archway - square
            translate( v = [0, thickness, base_thickness + box_width/2/2 + 6.25] ) {
                # cube( size = [box_width, thickness * 2, box_width/2 + 12.5], center = true );
                
            }

				// archway - open
            translate( v = [0, thickness, box_width * 2] )
				cube(size = [box_width - 10, thickness * 2, box_width*2], center = true);
        }

    }

}

union() {
    for (z = [ base_separation : base_separation : units * base_separation ] ) {
        translate( v = [z - (units/2 * base_separation) - base_separation/2, 0, 0]) {
            nespresso_base();
            translate( v = [0,0,-base_thickness/2]) {
                nespresso_base_tube();
            }
        }
    }
}

translate([90, 30, 1.25])
	cylinder(0.5, 25, 25, true);

translate([90, -40, 1.25])
	cylinder(0.5, 25, 25, true);


translate([-90, 30, 1.25])
	cylinder(0.5, 25, 25, true);

translate([-90, -40, 1.25])
	cylinder(0.5, 25, 25, true);


