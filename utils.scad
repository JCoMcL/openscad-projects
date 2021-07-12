module nm(){children();}//for debugging
module cut(keep=undef){ //removes overlapping space
	if(is_undef(keep) || keep){
		difference(){
			children(0);
			children([1:$children-1]);
	}}
	if(is_undef(keep) || !keep){
	difference(){
		children([1:$children-1]);
		difference(){
			children(0);
			children([1:$children-1]);
}}}}
	
