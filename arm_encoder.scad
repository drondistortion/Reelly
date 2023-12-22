$fn=150;
$fa=0.1;
// inner stuff
washer_h = 3; //mm
bearing_h = 7;
screw_d = 4.3;

// outer stuff
full_rotation_length = 12; //cm
flange_size = 10; //mm
flange_h = 1;
encoder_h = 7;
minimum_measured_distance = 2; //cm
rubber_thickness = 0.75;

/* inner */
module shaft() {
	union() {
		cylinder(h=washer_h, d=15);
		cylinder(h=bearing_h+washer_h, d=7.7);	
	}
}

module shaftWasher() {
	difference() {
		shaft();
		translate([0,0,-1])cylinder(h=13, d=screw_d);
	}
}

module cap() {
	difference() {
		cylinder(h=washer_h, d=15);
		cylinder(h=3, d=screw_d);
	}
}

/* outer */

echo("*********************** encoder_d ******************");
encoder_d = 10*full_rotation_length/PI-rubber_thickness*2;
echo(encoder_d);
module encoderMainShaft() {
	union() {
		translate([0,0,flange_h])cylinder(h=encoder_h, d=encoder_d);
		bottom_flange();
		top_flange();
	}
}

module bottom_flange() {
	cylinder(h=flange_h, d=encoder_d+flange_size);
}

module top_flange() {
	translate([0,0,flange_h+encoder_h])difference() {
		// flange itself
		cylinder(h=flange_h, d=encoder_d+flange_size+5);
		// top hole
		cylinder(h=flange_h, d=18);
		distance_between_cutouts = 360/(full_rotation_length/minimum_measured_distance);
		// encoder cutouts
		for (cutout_angle = [0:distance_between_cutouts:360]) {
			rotate([0,0,cutout_angle])
				translate([0,encoder_d/2+flange_size/2,1])
					cube([flange_size/2,flange_size,flange_h*3],true);
		}
	}
}

module encoder() {
	difference() {
		encoderMainShaft();
		cylinder(h=flange_h+encoder_h, d=22);
	}
}

/* opto holder */
module optocouple() {
	cube([13,6.5,1]);
	cube([4,6.5,7.5]);
	translate([9,0,0])cube([4,6.5,7.5]);
}

module opto_holder() {
	arm_width = 6;
	arm_length = encoder_d/2+flange_size/2+0.5;
	opto_lenght = 13;
	union() {
		shaftWasher();
		// arm
		translate([arm_width,-arm_width/2,0])cube([arm_length,arm_width,1]);
		// holder
		translate([arm_length+arm_width-2,-arm_width/2,0])cube([6,arm_width, opto_lenght+flange_h+5]);
	}
}

module opto_legs() {
	legs_d = 1.2;
	legs_l = 7;
	cylinder(h=legs_l, d=legs_d);
	translate([0,2.5,0])cylinder(h=legs_l, d=legs_d);
	translate([10.2,2.5,0])cylinder(h=legs_l, d=legs_d);
	translate([10.2,0,0])cylinder(h=legs_l, d=legs_d);
}

/*
// draw encoder
color("RoyalBlue")translate([0,0,washer_h-1])
	encoder();
	*/

// draw optocouple holder
module opto_with_washer() {
	color("LightSlateGray")difference() {
		opto_holder();
		translate([encoder_d/2+1+flange_size/2+10,-1.25,6])rotate([0,-90,0])
			opto_legs();
	}
}

arm_length = 100;
arm_height = 7.5;

module slide() {
	this_r = arm_length;
	difference() {
		translate([-58,0,-arm_height+1])cylinder(h=arm_height,r=this_r);
		translate([-62,0,-arm_height+1])cylinder(h=arm_height,r=this_r);
	}
}

module spring_ring() {
	difference() {
		cylinder(h=3, d=6);
		cylinder(h=3, d=3);
	}
}

module arm() {
	arm_width = 15;
	difference() {
		union() {
			translate([25,arm_width/2,-3.5])rotate([0,90,0])
				spring_ring();
			translate([-60,-arm_width/2,-arm_height+1])
				cube([arm_length, arm_width, arm_height]);
			translate([-60,0,-arm_height+1])
				cylinder(h=arm_height, d=arm_width);
		}
		translate([-60,0,-arm_height+1])cylinder(h=arm_height, d=4.2);
		slide();

		// guide
		translate([39,0,1+2])
			cube(15, true);
		//translate([39,0,-arm_height-5.5]) cube(15, true);
		translate([-10,0,-10])
			cylinder(h=20, d=screw_d);
		translate([-10,0,-10])
			cylinder(h=10, d=7.9, $fn=6);
	}
}

module screw() {
	shaft_d = 3;
	head_d = 6;
	union() {
		cylinder(h=10,d=shaft_d);
		hull() {
			linear_extrude(0.1)
				circle(d=head_d);
			translate([0,0,head_d-shaft_d])
				linear_extrude(0.1)circle(d=shaft_d);
		}
	}
}

module rail() {
	rail_r = arm_length;
	rail_w = 43;
	common_x = 64;
	_h = 3.2;
	union() {
		difference() {
			translate([54,-rail_w/2,-arm_height+1])cube([20,rail_w,_h]);
			translate([-33,0,-arm_height+1])cylinder(h=arm_height+0.2,r=rail_r);
		}
		translate([common_x,-rail_w/2,-arm_height+1])cube([10,2,_h]);
		translate([common_x,rail_w/2-2,-arm_height+1])cube([10,2,_h]);
		translate([common_x,-rail_w/2,-arm_height+1])cube([10,rail_w,0.8]);
		translate([common_x,-rail_w/2,-arm_height+4.2])cube([10,rail_w,0.8]);
	}
}


module rail_with_skrewholes() {
	difference() {
		rail();
		translate([70,-15,-2.5])rotate([0,180,0])screw();
		translate([70,15,-2.5])rotate([0,180,0])screw();
	}
}
rail_with_skrewholes();

/*
union() {
	arm();
	//color("Silver")slide();
	translate([-10,0,0])rotate([0,0,-6])opto_with_washer();
}
*/

/*
// draw optocouple
translate([encoder_d/2+9,-3.25,4.5])rotate([0,-90,0])color("Black")
	optocouple();
	*/


