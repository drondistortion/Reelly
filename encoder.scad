$fn=50;
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
		//translate([0,0,flange_h])cylinder(h=encoder_h, d=encoder_d);
		translate([0,0,flange_h])crown($fn=150);
		//bottom_flange();
		top_flange();
	}
}

module bottom_flange() {
	cylinder(h=flange_h, d=encoder_d);
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
		translate([arm_length+arm_width-2,-arm_width/2,0])cube([3,arm_width, opto_lenght+flange_h+5]);
	}
}

module opto_legs() {
	legs_d = 1.2;
	cylinder(h=5, d=legs_d);
	translate([0,2.5,0])cylinder(h=5, d=legs_d);
	translate([10.2,2.5,0])cylinder(h=5, d=legs_d);
	translate([10.2,0,0])cylinder(h=5, d=legs_d);
}

module crown() {
	translate([0,0,encoder_h/2-0.5]) difference() {
		cut_h = 16;
		sphere(d=encoder_d);
		translate([0,0,encoder_h/2+0.5])cylinder(h=cut_h, d=40);
		translate([0,0,-cut_h-encoder_h/2-0.5])cylinder(h=cut_h, d=40);
	}
}

// draw encoder
color("RoyalBlue")translate([0,0,washer_h-1])
	encoder();

/*
// draw optocouple holder
color("LightSlateGray")difference() {
	opto_holder();
	translate([encoder_d/2+1+flange_size/2+7,-1.25,6])rotate([0,-90,0])
		opto_legs();
}

// draw optocouple
translate([encoder_d/2+9,-3.25,4.5])rotate([0,-90,0])color("Black")
	optocouple();
*/
