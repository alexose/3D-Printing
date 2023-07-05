# Dorothy - A Minimalist LoRa Sensor Platform

Dorothy is a minimalist, hackable, low-cost sensor platform built around the LoRa protocol. It uses the
[CubeCell V2](https://heltec.org/project/htcc-ab01-v2/) board and off-the-shelf sensors to deliver readings to a central
hub.

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

Begin by sourcing the materials you'll need to build a [Hub](#hub) and at least one [Sensor](#sensor):

-   [Heltec WiFi LoRa 32 v3](https://heltec.org/project/wifi-kit-32-v3/)
-   [Heltec CubeCell AB01 v2](https://heltec.org/project/htcc-ab01-v2/)
-   At least three [18650 cells](https://www.amazon.com/s?k=18650)
-   Some [solid core wire](https://www.amazon.com/s?k=solid+core+wire)
-   [M2 screws](https://www.amazon.com/s?k=m2+screws+phillips) of assorted lengths

And your choice of:

-   [DHT22 Temperature/Humidity Sensor](https://www.amazon.com/dht22/s?k=dht22)
-   [US-100 Ultrasonic Distance Sensor](https://www.amazon.com/s?k=us100+sensor&ref=nb_sb_noss)
-   [I2C Soil Moisture Sensor](https://www.tindie.com/products/miceuz/i2c-soil-moisture-sensor/)

Begin by printing the enclosure to the Dorothy Hub.

<h2 name="hub">Dorothy Hub</h2>

The hub is a bridge between the battery-powered sensors and your WiFi network.

The current version of the hub uses a [Heltec WiFi LoRa 32](https://heltec.org/project/wifi-kit-32-v3/) board instead of
a CubeCell. While it is slightly more expensive, the WiFi LoRa 32 has an included OLED screen, which makes it easier to
debug. The same code should also work on the CubeCell, but I haven't tested it.

<h2 name="sensor">Dorothy Sensor</h2>

Dorothy is designed around the [Cylindrical Battery Holder](https://www.thingiverse.com/thing:6080710) project, allowing
easy swapping of cells. Alternatively, the whole battery can be quickly swapped in the field.

## The Dorothy Protocol

Dorothy

## Usage

To use Dorothy, follow the assembly instructions. Once assembled, the device should start transmitting data to the
central hub.

## Contributing

As Dorothy is an open-source project, contributions are always welcome! Check out the [CONTRIBUTING.md](link to
contributing guide) to get started.

## License

Dorothy is licensed under [insert license here](link to license).
