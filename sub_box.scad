
inner_length = 280;
inner_width = 88;
inner_height = 100;
finger_length = 10;
thickness = 4;
flange_hole_dist = 20;
flange_hole_diam = 4;
flange_hole_offset = 4;
flange_width = flange_hole_offset * 2;
$fn=50;

module fingers(length) {
  count = round(length / (finger_length * 2) + 0.5);
  l = length / ((count * 2) - 1);
  echo(l);
  for (i = [0:count - 1]) {
    translate([i*2*l,-1]) {
      square([l, thickness+1]);
    }
  }
}
// Array order: low y, high y, low x, high x
module panel(x_size, y_size, thickness, fingers=[true,true,true,true], invert=[false,false,false,false])
{
  x_low = invert[2] ? -thickness : 0;
  x_high = x_size + (invert[3] ? thickness : 0);
  y_low = invert[0] ? -thickness:0;
  y_high = y_size + (invert[1] ? thickness : 0);
  difference() {
    union() {
      translate([x_low, y_low]) {
	square([x_high - x_low, y_high - y_low]);
      }
      translate([-thickness,0]) {
	if (fingers[0] && !invert[0]) {
	  scale([1,-1]) {
	    fingers(x_size+thickness*2);
	  }
	}
	if (fingers[1] && !invert[1]) {
	  translate([0,y_size]) {
	    fingers(x_size+thickness*2);
	  }
	}
      }
      rotate(90) {
	if (fingers[2] && !invert[2]) {
	  translate([-thickness,0]) {
	    fingers(y_size+thickness*2);
	  }
	}
	if (fingers[3] && !invert[3]) {
	  translate([-thickness,-inner_length]) {
	    scale([1,-1]) {
	      fingers(y_size+thickness*2);
	    }
	  }
	}
      }
    }
    if (fingers[0] && invert[0]) {
      translate([-thickness,-thickness]) {
	fingers(x_size+thickness*2);
      }
    }
    if (fingers[1] && invert[1]) {
      translate([-thickness,y_size+thickness]) {
	scale([1,-1]) {
	  fingers(x_size+thickness*2);
	}
      }
    }
    rotate(90) {
      if (fingers[2] && invert[2]) {
	translate([-thickness,thickness]) {
	  scale([1,-1]) {
	    fingers(y_size+thickness*2);
	  }
	}
      }
      if (fingers[3] && invert[3]) {
	translate([-thickness,-x_size-thickness]) {
	  fingers(y_size+thickness*2);
	}
      }
    }
  }
}

module bottom() {
  panel(inner_length, inner_width, thickness);
}

module side_flat_top() {
  panel(inner_width, inner_height, thickness, [true,true,true,false], [false,false, false, false]);
}

module side() {
  panel(inner_length, inner_height, thickness, [true,true,true,true], [true,false,false,false]);
}

module end_flat_top() {
  difference() {
    translate([-thickness,-thickness]) {
      square([inner_width+thickness*2,inner_height+ thickness]);
    }
    rotate(90) {
      translate([-thickness,thickness]) {
	scale([1,-1]) {
	  fingers(inner_height+thickness);
	}
      }
      translate([-thickness,-inner_width-thickness]) {
	fingers(inner_height+thickness,0);
      }
    }
    translate([-thickness,-thickness]) {
      fingers(inner_width+thickness*2,0);
    }
  }
}


module end() {
  panel(inner_width, inner_height, thickness, [true,true,true,true], [true,false,true,true]);
}

module flange_holes() {
  hole_offset = thickness+flange_hole_offset;
  edge_offset = thickness + flange_width;
   x_count = round((2*hole_offset + inner_length)/flange_hole_dist);
    x_dist = (2*hole_offset + inner_length) / x_count;
    for (i = [1:x_count-1]) {
      translate([i*x_dist-hole_offset, 0]) {
	translate([0,-hole_offset]) {
	  circle(d=flange_hole_diam);
	}
	translate([0,inner_width + hole_offset]) {
	  circle(d=flange_hole_diam);
	}
      }
    }
    y_count = round((2*hole_offset + inner_width)/flange_hole_dist);
    y_dist = (2*hole_offset + inner_width) / y_count;
    for (i = [0:y_count]) {
      translate([0,i*y_dist-hole_offset]) {
	translate([-hole_offset,0]) {
	  circle(d=flange_hole_diam);
	}
	translate([inner_length + hole_offset,0]) {
	  circle(d=flange_hole_diam);
	}
      }
    }
}
module lid() {
  hole_offset = thickness+flange_hole_offset;
  edge_offset = thickness + flange_width;
  difference() {
    union() {
      translate([-edge_offset, -hole_offset]) {
	square([2*edge_offset + inner_length, 2*hole_offset + inner_width]);
      }
      translate([-hole_offset, -edge_offset]) {
	square([2*hole_offset + inner_length, 2*edge_offset + inner_width]);
      }
      for (p = [[-hole_offset, ,-hole_offset],
		[-hole_offset, inner_width + hole_offset],
		[inner_length + hole_offset, -hole_offset],
		[inner_length + hole_offset, inner_width + hole_offset]]) {
	translate(p) {
	  circle(r=flange_width - flange_hole_offset);
	}
      }
    }
    flange_holes();
  }
}

module flange() {
  difference() {
    lid();
    bottom();
  }
}
 
