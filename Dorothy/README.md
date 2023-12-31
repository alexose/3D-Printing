# Dorothy - A Minimalist LoRa Sensor Platform

Dorothy is a minimalist, open-source, low-cost sensor platform built around the LoRa protocol. It uses the
[CubeCell V2](https://heltec.org/project/htcc-ab01-v2/) board and common off-the-shelf [sensors](#sensor) to deliver
readings to a central [hub](#hub), and only needs to be recharged about once per year.

Data is stored using [InfluxDB](https://www.influxdata.com/) and visualized with [Grafana](https://grafana.com/). This
software can be [run in the cloud](https://www.influxdata.com/influxcloud-trial/) or on a local Linux server.

Dorothy is aimed at anyone who wants to build a robust sensor network as cheaply as possible without being locked into a
proprietary platform.

## Key Features

-   **3D Printable**: All components are fully 3D printable with no supports.
-   **Weatherproof**: Designed to live outside year round.
-   **Long Range**: Capable of a range of at least 1/4 mile (400m).
-   **Long Battery Life**: Designed for a battery life of one year.
-   **Easy to Assemble/Disassemble**: From the moment you're done printing, it takes about 20 minutes to assemble a
    working Dorothy, requiring minimal tools and skill. Just mount the components, screw it together, and you're set.
-   **Low Cost**: Around $25 per unit, including batteries
-   **Easy-to-read Codebase**: The codebase is designed to be compact and easy to understand.
-   **Open Licensing**: Dorothy comes with a fully open license.

## How to build

Begin by sourcing the materials you'll need to build a [hub](#hub) and at least one [sensor](#sensor):

-   [Heltec WiFi LoRa 32 v3](https://heltec.org/project/wifi-kit-32-v3/) (For the hub)
-   [Heltec CubeCell AB01 v2](https://heltec.org/project/htcc-ab01-v2/) (For each sensor)
-   At least three [18650 cells](https://www.amazon.com/s?k=18650)
-   Some [solid core wire](https://www.amazon.com/s?k=solid+core+wire)
-   [M2 screws](https://www.amazon.com/s?k=m2+screws+phillips) of assorted lengths
-   [1.25mm 2 pin Male JST Connectors](https://www.amazon.com/s?k=1.25mm+2pin+male+jst)
-   (Optional) These [pluggable LED Wire Connectors](https://www.amazon.com/s?k=Pluggable+LED+Wire+Connectors) which
    make it easy to quickly swap batteries in the field

And (depending on what you want to measure) your choice of:

-   [DHT22 Temperature/Humidity Sensor](https://www.amazon.com/dht22/s?k=dht22)
-   [US-100 Ultrasonic Distance Sensor](https://www.amazon.com/s?k=us100+sensor&ref=nb_sb_noss)
-   [I2C Soil Moisture Sensor](https://www.tindie.com/products/miceuz/i2c-soil-moisture-sensor/)

<h2 name="hub">Dorothy Hub</h2>

The hub is a bridge between the battery-powered sensors and your WiFi network.

The current version of the hub uses a [Heltec WiFi LoRa 32](https://heltec.org/project/wifi-kit-32-v3/) board instead of
a CubeCell. The WiFi LoRa 32 has an included OLED screen, which makes it easier to debug, but is missing some of the key
battery management and low-power features of the CubeCell.

Note that the same code should also work on the CubeCell, but I haven't tested it.

<h2 name="sensor">Dorothy Sensor</h2>

Dorothy is designed around the [Cylindrical Battery Holder](https://www.thingiverse.com/thing:6080710) project, allowing
for easy battery packs swaps.

## The Dorothy Protocol

Dorothy borrows heavily from the
[InfluxDB Line Protocol](https://docs.influxdata.com/influxdb/v1.3/write_protocols/line_protocol_tutorial/)

## Future Work

While Dorothy has undergone over two years of development and testing at this point, there are still several
improvements that may appear in a future revision.

First on the list is improving the way the CubeCell board secures to the "brain". I'd love to get rid of those M2
screws, but I wasn't satisfied with any of the solutions I attempted.

Second is supporting more types of sensors, especially PIR sensors and even things like MEMS microphones.

Finally, there's always room to improve the software. Improvement doesn't necessarily mean adding features, however, but
making it simplier and easier to build on top of.

## Contributing

As Dorothy is an open-source project, contributions are always welcome! Check out the [CONTRIBUTING.md](link to
contributing guide) to get started.

## License

Dorothy is licensed under [insert license here](link to license).
