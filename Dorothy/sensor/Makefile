.PHONY: all outer_shell distance_sensor soil_moisture_sensor temperature_humidity_sensor

all: outer_shell distance soil_moisture temperature_humidity

outer_shell:
	openscad dorothy_sensor.scad -D render_outer_shell=1 -D render_brain=0 -o outer_shell.stl --enable=fast-csg

distance:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type=\"distance\" -o distance_brain.stl --enable=fast-csg

soil_moisture:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type=\"soil_moisture\" -o soil_moisture_brain.stl --enable=fast-csg

temperature_humidity:
	openscad dorothy_sensor.scad -D render_outer_shell=0 -D render_brain=1 -D brain_type=\"temperature_humidity\" -o temperature_humidity_brain.stl --enable=fast-csg
