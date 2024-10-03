include <sub_box.scad>
translate([0,0,-thickness]) {
  linear_extrude(height=thickness) {
    bottom();
  }
}
color("red") {
  for (y =[0, inner_width+thickness]) {
    translate([0,y,0]) {
    rotate([90,0,0]) {
      linear_extrude(height=thickness) {
	side();
      }
    }
    }
  }
}
color("green") {
  for (x =[-thickness, inner_length]) {
    translate([x,0,0]) {
    rotate([90,0,90]) {
      linear_extrude(height=thickness) {
	end();
      }
    }
    }
  }
}

color("blue") {
  translate([0,0,inner_height]) {
    linear_extrude(height=thickness) {
      flange();
    }
  }
}

translate([0,0,inner_height+ 30]) {
  linear_extrude(height=thickness) {
    lid();
  }
}
