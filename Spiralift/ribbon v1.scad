r=40;
thickness=2;
loops=5;
scale(0.4) {
    linear_extrude(height=30) polygon(points= concat(
        [for(t = [90:360*loops]) 
            [(r-thickness+t/90)*sin(t),(r-thickness+t/90)*cos(t)]],
        [for(t = [360*loops:-1:90]) 
            [(r+t/90)*sin(t),(r+t/90)*cos(t)]]
            ));
    }   