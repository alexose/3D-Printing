module section(r=80, thickness=3.5, loops=5) {
    scale(0.25) {
        linear_extrude(height=50) polygon(points= concat(
            [for(t = [90:360*loops]) 
                [(r-thickness+t/90)*sin(t),(r-thickness+t/90)*cos(t)]],
            [for(t = [360*loops:-1:90]) 
                [(r+t/90)*sin(t),(r+t/90)*cos(t)]]
                ));
        }
}

section();

// Add tapering outer ring
//section(100, 3.5, 1);