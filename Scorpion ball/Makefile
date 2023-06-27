.PHONY: all inner_shell outer_shell bottom_half wrench

all: inner_shell outer_shell bottom_half wrench

inner_shell:
	openscad scorpion_ball.scad -D render_inner_shell=1 -D render_outer_shell=0 -D render_bottom_half=0 -D render_wrench=0 -o inner_shell.stl --enable=fast-csg

outer_shell:
	openscad scorpion_ball.scad -D render_inner_shell=0 -D render_outer_shell=1 -D render_bottom_half=0 -D render_wrench=0 -o outer_shell.stl --enable=fast-csg

bottom_half:
	openscad scorpion_ball.scad -D render_inner_shell=0 -D render_outer_shell=0 -D render_bottom_half=1 -D render_wrench=0 -o bottom_half.stl --enable=fast-csg

wrench:
	openscad scorpion_ball.scad -D render_inner_shell=0 -D render_outer_shell=0 -D render_bottom_half=0 -D render_wrench=1 -o wrench.stl --enable=fast-csg
