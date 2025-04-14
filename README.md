# Verilog-SE050-Interface
Verilog Interface between Arty A7-100T FPGA and SE050 Secure Element

OVERVIEW

This  module is designed to interface with an ADT7420 temperature sensor and an SE050 secure element over the I2C bus. The module reads temperature data from the ADT7420, hashes and signs the temperature values using the SE050, and displays the status of operations on a 7-segment display.

FEATURES

- I2C Communication: Interfaces with ADT7420 and SE050 using the I2C protocol.
- Temperature Reading: Reads temperature data from the ADT7420 sensor.
- Hashing and Signing: Hashes and signs the temperature sensor values using the SE050.
- Resynchronization Packet: Sends a resynchronization packet to the SE050.
- 7-Segment Display: Displays the status of operations on a 7-segment display.

REQUIREMENTS

- I2C Master Module: The `top` module requires an `i2c_master` module to handle the I2C communication. Ensure that the `i2c_master` module is included in your project.

HARDWARE SETUP

DEVICES USED

- ADT7420: Temperature sensor.
- SE050: Secure element for cryptographic operations.

PULL-UP RESISTORS

- I2C Bus: Pull-up resistors are required on the SDA and SCL lines. 10kΩ resistors were used for testing.

PIN CONNECTIONS

I2C INTERFACE FOR ADT7420

- SCL (Clock Line): Connect to the `tmp_scl` pin.
- SDA (Data Line): Connect to the `tmp_sda` pin.

I2C INTERFACE FOR SE050

- SCL (Clock Line): Connect to the `se_scl` pin.
- SDA (Data Line): Connect to the `se_sda` pin.

7-SEGMENT DISPLAY

- Anode Control: Connect to the `anode` pins.
- Segment Control: Connect to the `_7LED` pins.

EXAMPLE PIN CONFIGURATION (XDC FILE)

I2C Interface for ADT7420
set_property PACKAGE_PIN <TMP_SCL_PIN> [get_ports tmp_scl] set_property IOSTANDARD LVCMOS33 [get_ports tmp_scl] set_property PULLUP true [get_ports tmp_scl]
set_property PACKAGE_PIN <TMP_SDA_PIN> [get_ports tmp_sda] set_property IOSTANDARD LVCMOS33 [get_ports tmp_sda] set_property PULLUP true [get_ports tmp_sda]

I2C Interface for SE050
set_property PACKAGE_PIN <SE_SCL_PIN> [get_ports se_scl] set_property IOSTANDARD LVCMOS33 [get_ports se_scl] set_property PULLUP true [get_ports se_scl]
set_property PACKAGE_PIN <SE_SDA_PIN> [get_ports se_sda] set_property IOSTANDARD LVCMOS33 [get_ports se_sda] set_property PULLUP true [get_ports se_sda]

7-Segment Display
set_property PACKAGE_PIN <ANODE_PIN_0> [get_ports anode[0]] set_property PACKAGE_PIN <ANODE_PIN_1> [get_ports anode[1]]
Repeat for all anode pins...
set_property PACKAGE_PIN <SEGMENT_PIN_0> [get_ports _7LED[0]] set_property PACKAGE_PIN <SEGMENT_PIN_1> [get_ports _7LED[1]]
Repeat for all segment pins...

Replace `<TMP_SCL_PIN>`, `<TMP_SDA_PIN>`, `<SE_SCL_PIN>`, `<SE_SDA_PIN>`, `<ANODE_PIN_0>`, `<ANODE_PIN_1>`, `<SEGMENT_PIN_0>`, `<SEGMENT_PIN_1>`, etc., with the actual pin numbers used in your hardware setup.

MODULE PORTS

INPUTS

- clk: 100MHz input clock.
- rst: Reset signal (active low).
- TMP_INT: Over-temperature and under-temperature indicator from ADT7420.
- TMP_CT: Critical over-temperature indicator from ADT7420.

I2C INTERFACE FOR ADT7420

- tmp_scl: I2C clock line for the temperature sensor.
- tmp_sda: I2C data line for the temperature sensor.

I2C INTERFACE FOR SE050

- se_scl: I2C clock line for the SE050.
- se_sda: I2C data line for the SE050.

7-SEGMENT DISPLAY

- anode: Anode control for the 7-segment display.
- _7LED: Segment control for the 7-segment display.

INTERNAL REGISTERS AND PARAMETERS

- I2C Addresses: Defines the I2C addresses for the ADT7420 and SE050.
- Configuration Bits: Configuration settings for the ADT7420.
- State Machine: Manages the states for reading temperature data, hashing and signing the values, and sending the resynchronization packet.

STATE MACHINE

The state machine handles the following states:

1. SETUP: Initializes the I2C communication with the ADT7420.
2. VERIFY_ID: Verifies the device ID of the ADT7420.
3. WRITE_CONFIG: Writes configuration settings to the ADT7420.
4. TEMP_DATA_AQ: Acquires temperature data from the ADT7420.
5. SE_SETUP: Sets up the I2C communication with the SE050.
6. SE_WRITE_REQ: Sends a write request to the SE050.
7. SE_AWAIT_ACK: Waits for acknowledgment from the SE050.
8. SE_READ_SETUP: Sets up the read operation from the SE050.
9. SE_READ_REQ: Sends a read request to the SE050.
10. SE_READ_AWAIT: Waits for data from the SE050.
11. SE_READ_FINISH: Completes the read operation from the SE050.
12. HASH_AND_SIGN: Hashes and signs the temperature sensor values using the SE050.
13. ERROR: Handles errors in communication.

EXAMPLE USAGE

	module example_top ( input clk, input rst, input TMP_INT, input TMP_CT, inout tmp_scl, inout tmp_sda, inout se_scl, inout se_sda, output [7:0] anode, output [7:0] _7LED );

	top u_top ( .clk(clk), .rst(rst), .TMP_INT(TMP_INT), .TMP_CT(TMP_CT), .tmp_scl(tmp_scl), .tmp_sda(tmp_sda), .se_scl(se_scl), .se_sda(se_sda), .anode(anode), ._7LED(_7LED) );

	endmodule

NOTES

- Ensure that the `i2c_master` module is included in your project and correctly instantiated within the `top` module.
- The `i2c_master` module handles the low-level I2C communication, while the `top` module manages the high-level state machine and data processing.
- The 7-segment display is used to show the status of operations, including initialization, data acquisition, hashing, signing, and error states.


