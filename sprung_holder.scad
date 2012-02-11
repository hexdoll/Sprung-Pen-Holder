MP=1; //Manifold protection fudge number to prevent non-manifold shapes;

module nut_hole(
	RADIUS=2, //mm
)
{
	cylinder(r1=RADIUS+0.5, r2=RADIUS+0.5, h=60);
}


module bottom(
	MAX_PEN_RADIUS=10, //mm
	X_CARRIAGE_HOLE_RADIUS=20, //mm
	X_CARRIAGE_HOLE_DEPTH=5, //mm
	BOTTOM_HEIGHT = 20, //mm
	WALL_WIDTH=3, //mm
	HOLES = 4,
	BOLT_RADIUS=2, //mm
)
{
	color("green")
	difference()
	{
		union()
		{
			//ledge to hold drawing head in hole
			cylinder (r1=X_CARRIAGE_HOLE_RADIUS+2, r2=X_CARRIAGE_HOLE_RADIUS+2, h=X_CARRIAGE_HOLE_DEPTH);
			
			//plug for x-carriage hole
			translate([0,0,-5]) cylinder(r1=X_CARRIAGE_HOLE_RADIUS, r2=X_CARRIAGE_HOLE_RADIUS, h=X_CARRIAGE_HOLE_DEPTH);
		}

		//centre hole
		# translate([0,0,-50]) cylinder(r1=MAX_PEN_RADIUS, r2=MAX_PEN_RADIUS, h=100);

		//holes for screws
		for (i = [1:HOLES])
		{

			rotate([0,0,360/HOLES*i])
			translate([X_CARRIAGE_HOLE_RADIUS-BOLT_RADIUS,0,-20-MP])
			# cylinder(r1=1.5, r2=1.5, h=50, $fn=10);
		}

	}
}

module top(
	HOLES=4,
	HOLE_RADIUS=2, //mm
	MAX_PEN_RADIUS=10, //mm
	X_CARRIAGE_HOLE_RADIUS=20, //mm
	BOLT_RADIUS=2, //mm
)
{
	difference()
	{
		union()
		{
			cylinder(r1=X_CARRIAGE_HOLE_RADIUS-HOLE_RADIUS,r2=X_CARRIAGE_HOLE_RADIUS-HOLE_RADIUS,h=5);

			//loops to hold holes
			for (i = [1:HOLES])
			{
				rotate([0,0,360/HOLES*i])
				translate([X_CARRIAGE_HOLE_RADIUS-BOLT_RADIUS,0,0])
				cylinder(r1=BOLT_RADIUS*2, r2=BOLT_RADIUS*2, h=10);
			}
		}
		//screw holes
		for (i = [1:HOLES])
		{
			//holes for screws
			rotate([0,0,360/HOLES*i])
			translate([X_CARRIAGE_HOLE_RADIUS-BOLT_RADIUS, 0, -MP])
			# cylinder(r1=1.5, r2=1.5, h=15, $fn=10);
		}

		translate([0,0,-MP])
		# cylinder(r1=MAX_PEN_RADIUS, r2=MAX_PEN_RADIUS, h=10);
	}
}

module v_clamp_channel(
	MAX_PEN_RADIUS=10, //mm
	CLAMP_THICKNESS=3, //mm
	LENGTH=30, //mm
)
{
	translate([-CLAMP_THICKNESS-MAX_PEN_RADIUS, -CLAMP_THICKNESS-MAX_PEN_RADIUS,0])
	union()
	{
		cube([MAX_PEN_RADIUS*2+CLAMP_THICKNESS, CLAMP_THICKNESS, LENGTH]);
		translate([CLAMP_THICKNESS, 0, 0]) rotate([0, 0, 90]) cube([MAX_PEN_RADIUS*2+CLAMP_THICKNESS, CLAMP_THICKNESS, LENGTH]);
	}

	//translate([0,MAX_PEN_RADIUS,0])
	//rotate([0,0,45])
	//# cube([CLAMP_THICKNESS, 10, 20]);
}

module clamp(
	HOLE_RADIUS=2, //mm
	HOLE_DISTANCE=30, //mm
	EDGE=3, //mm
	HEIGHT=5, //mm
	WIDTH
)
{
	difference()
	{
		linear_extrude(height=HEIGHT)
		hull()
		{
			translate([HOLE_DISTANCE/2,0,0]) circle(HOLE_RADIUS+EDGE);
			translate([-HOLE_DISTANCE/2,0,0]) circle(HOLE_RADIUS+EDGE);
		}
		translate([HOLE_DISTANCE/2,0,-MP/2]) cylinder(r1=HOLE_RADIUS, r2=HOLE_RADIUS, h=HEIGHT+MP);
		translate([-HOLE_DISTANCE/2,0,-MP/2]) cylinder(r1=HOLE_RADIUS, r2=HOLE_RADIUS, h=HEIGHT+MP);
	}
}



bottom();
v_clamp_channel();
difference()
{
	top();	
	# translate([-10,-10,0]) cube([20,20,100]);
}
//translate ([0,0,10]) clamp();