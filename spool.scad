$fn = 50;
$fa = 0.1;
module spool_base() {
	sf = 1.018;
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

//spool_base();
spool_top();
