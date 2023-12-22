//cube(14);

module cutout(size, r, h) {
	hull() {
		translate([r,r,0])cylinder(r=1, h=h);
		translate([size-r,r,0])cylinder(r=r, h=h);
		translate([r,size-r,0])cylinder(r=1, h=h);
		translate([size-r,size-r,0])cylinder(r=1, h=h);
	}
}

module panel_base() {
	cube([18,14*4,10]);
}

module mount() {
	d=8;
	h=10;
	difference() {
		hull() {
			translate([0,0,h/2])cube([0.1,8,h],true);
			translate([d/2,0,0])cylinder(h=10,d=d);
		}
	translate([d/2,0,0])cylinder(h=10,d=4.5);
	}
}

module panel() {
	difference() {
		panel_base();
		for (i=[0:2]) {
			translate([2,3.5+i*18,0])cutout(14,1,11,$fn=30);
		}
		translate([1,1,0])scale([0.9,1,0.9])panel_base();
	}
}

//panel();

union() {
	panel();
	rotate([0,0,-90])translate([0,9,0])mount($fn=30);
	rotate([0,0,90])translate([14*4,-9,0])mount($fn=30);
	translate([0,14*4,0])cube([10,1,10]);
	translate([8,14*4,3])cube([10,1,7]);
}
