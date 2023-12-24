$fn = 50;
$fa = 0.1;
module spool_base() {
	sf = 1.018; // scale factor
	union() {
		scale([sf,sf,sf])import("fh_spool.stl");
		difference() {
			cylinder(h=7.13, d=28);
			cylinder(h=6, d=22);
			cylinder(h=7.14, d=18);
		}
	}
}

module spool_top() {
	difference() {
		spool_base();
		cylinder(d=35, h=10);
	}
}

module platform() {
	difference() {
		spool_top();
		cutout();
	}
}

module cutout() {
	difference() {
		cylinder(h=10, r=80);
		cylinder(h=11, r=42);
	}
}

module spoolWithOffset() {
	union() {
		spool_top();
		translate([0,0,2])platform();
	}
}

//spool_base();
spoolWithOffset();
