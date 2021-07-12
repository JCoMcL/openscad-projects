use <fingerbox.scad>
use <utils.scad>

keepmode = 0; // 0: both, 1: vertical, 2: horizontal

X = 518; // primary width
Y = 440; // primary length
Z = 430; // primary height
T0 = 11; // primary thickness
fW = 16; // finger width, set to same value as T0 for most predictable results

module scut(){ //hack to circumvent implicit union. should allow vertical and horizontal parts to be rendered seperately
	cut([undef, true, false][keepmode]){
		children(0);
		children([1:$children-1]);
}}

module halfSlot(swap=false, direction=[0,1,0]){
	scale([for (i = direction) 1 - i/2]) intersection(){
		children(0);
		children(1);
}}

module halfSlotted(swap=true, really=true){
	if (really){
		scut(){
		children(swap ? 1:0);
		difference(){
			children(swap ? 0:1);
			halfSlot(){
				children(0);
				children(1);
		}}}
	}else if (keepmode == 0){
		children(0);
		children(1);
	}else {
		children(keepmode - 1);
	
}}

module pillar(bottom=0, top=Z)	{
	fingers = [
		0,
		0,
		bottom == 0 ? 0 : 1,
		top == Z ? 0 : 1
	];
	translate([0,0,top]) rotate([0, 90, 0]) linear_extrude(T0) fingerplane(top - bottom, Y, fW, T0, fingers);
}

module shelf(left=0, right=X)	{
	fingers = [
		0,
		0,
		right == X ? 0 : 1,
		left == 0 ? 0 : 1
	];
	translate([left,0,0]) linear_extrude(T0) fingerplane(right - left, Y, fW, T0, fingers);
}

module grid(u, v, bounds=[Z,0,X,0]){
	height = bounds[0] - bounds[1];
	width = bounds[2] - bounds[3];
		
	halfSlotted(true, v > 1 && u > 1){
		if (u > 1) {for (i = [1:u-1]){
			translate([0, 0, bounds[1] + (height/u) * i]) shelf(bounds[3], bounds[2]);
		}}
		if (v > 1) {for (i = [1:v-1]){
			translate([bounds[3] + (width/v) * i, 0, 0]) pillar(bounds[1], bounds[0]);
		}}
}}

module finalProject(){
	if (keepmode == 0) {children();}
	else if (keepmode == 1) {projection() rotate([90,0,0]) children();}
	else {projection() children();}
}
//grid(3, 3);

grid(2, 2, [Z, 120, X, 0]);
grid(1, 3, [120 + T0, 0, X, 0]);

//grid(1, 3, [Z, 300, X, 0]);
//grid(1, 2, [300 + T0, 0, X, 0]);
//grid(3, 1, [300 + T0, 0, X, X  / 2]);
