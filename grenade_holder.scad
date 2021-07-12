GDiam = 40;
Overhang = 5;
Elevation = 6;

X = GDiam + 5;
Y = 30;
Z = GDiam / 2 + Overhang + Elevation;

hR = 10;
hD = 3;
hZ = 5;
difference(){
	union(){
		translate([0,Y/2,0]) { 
			translate([-hD,0,0]) cylinder(hZ, hR, hR);
			translate([X+hD,0,0]) cylinder(hZ, hR, hR);
		}
		translate([-hD,Y/2-hR,0]) cube([X + (hD * 2) ,hR * 2,5]);
		cube([X,Y,Z]);
	}
translate([X/2, Y, Z-Overhang]) rotate([90, 0, 0]) cylinder(Y, GDiam / 2 , GDiam / 2);
}
