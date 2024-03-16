.PHONY: all

all: stylus housing ball_without_stylus track_cylinder 

stylus:
	openscad spiral_trackers.scad -D render_stylus=1 -D render_housing=0 -D render_ball_without_stylus=0 -D render_track_cylinder=0 -o base.stl --enable=fast-csg

housing:
	openscad spiral_trackers.scad -D render_stylus=0 -D render_housing=1 -D render_ball_without_stylus=0 -D render_track_cylinder=0 -o housing.stl --enable=fast-csg

ball_without_stylus:
	openscad spiral_trackers.scad -D render_stylus=0 -D render_housing=0 -D render_ball_without_stylus=1 -D render_track_cylinder=0 -o ball_without_stylus.stl --enable=fast-csg

track_cylinder:
	openscad spiral_trackers.scad -D render_stylus=0 -D render_housing=0 -D render_ball_without_stylus=0 -D render_track_cylinder=1 -o track_cylinder.stl --enable=fast-csg
