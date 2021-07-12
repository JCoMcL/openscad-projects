X = 228; // primary width
Y = 300; // primary length
Z = 88; // primary height
T0 = 8; // primary thickness
fW = 18; // finger width, set to same value as T0 for most predictable results

function div(num, denom) = num / round(num / denom);
function splice(v1, v2)
=	[for (i = [0 : len(v1) + len(v2) - 1]) (i%2) ? v1[i/2] : v2[floor(i/2)]];

function triangleWave(width,height,count, phase=0)
=	[for (i = [0 : count]) [i*width, ((i+phase)%2)*height]]; 
function squareWave(width,height,count)
=	splice(triangleWave(width,height,count),triangleWave(width,height,count,1));

module fingers(width,height,length,swap=false){
	width = div(length,width);
	for(i=[swap ? 0 : width : width*2: length]){
		translate([i,0,0])
		square([width, height]);
}}
module offsetsquare(width, height, offset, offsets=[1,1,1,1]){
	translate(offset*[offsets[2],offsets[0]])
		square(	[width-offset*(offsets[2] + offsets[3]),
			height-offset*(offsets[0] + offsets[1])]
		);
		
}
module fingerplane(width,height,fingerWidth,fingerHeight,sides=[1,1,1,1]){
	difference(){
		square([width, height]);
	union() {
	if (sides[0]) {
		fingers(fingerWidth, fingerHeight, width, true);
	}
	if (sides[1]) {
		translate([0,height-fingerHeight,0])
			fingers(fingerWidth, fingerHeight, width);
	}
	if (sides[3]) {
		mirror([1,0,0])
			rotate([0,0,90])
				fingers(fingerWidth, fingerHeight, height);
	}
	if (sides[2]) {
		translate([width-fingerHeight,0,0])
			mirror([1,0,0])
				rotate([0,0,90])
					fingers(fingerWidth, fingerHeight, height, true);
	}
			
}}}

module ZnPlane(){
	linear_extrude(T0) fingerplane(X,Y,fW,T0);
}
module YnPlane(){	
	rotate([90,0,0]) translate([0,0,-T0]) linear_extrude(T0) fingerplane(X,Z,fW,T0,[0,0,1,1]);
}
module XnPlane(){
	rotate([0,-90,0]) translate([0,0,-T0]) linear_extrude(T0) fingerplane(Z,Y,fW,T0,[0,0,0,0]);
}
module ZpPlane(){
	translate([0,0,Z-T0]) ZnPlane();
}
module YpPlane(){
	translate([0,Y-T0,0]) YnPlane();
}
module XpPlane(){
	translate([X-T0,0,0]) XnPlane();
}

ZnPlane();
YnPlane();
XnPlane();
