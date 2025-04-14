`timescale 1fs / 1fs
module top(
    //All outputs are for tying directly to pinout on board Nexys 4 DDR (see constraints file)
    input clk,          //100MHz input crystal
    input rst,          //reset is tied to a switch on the board (active low)
    
    //ADT7420 Interface
    inout scl,      //I2C SCL for temperature sensor
    inout sda,      //I2C SDA for temperature sensor
    input TMP_INT,      //over temperature and under temperature indicator, (Denotes active when temperature is greater than what is stored in THIGH register)
    input TMP_CT,       //Critical over-temperature indicator
    
    //SE050 Interface
    inout se_scl,       //I2C SCL for SE050
    inout se_sda,       //I2C SDA for SE050
    
    //7Seg Display
    output [7:0] anode, 
    output [7:0] _7LED
    );


localparam [6:0] I2C_ADDR = 7'h4B;
localparam [7:0] DEVICE_ID = 8'hCB;

localparam [6:0] SE050_I2C_ADDR = 7'h48;

// SE050 Parameters
localparam [7:0] SELECT_APDU_0  = 8'h5A;
localparam [7:0] SELECT_APDU_1  = 8'h00;
localparam [7:0] SELECT_APDU_2  = 8'h16;
localparam [7:0] SELECT_APDU_3  = 8'h00;
localparam [7:0] SELECT_APDU_4  = 8'hA4;
localparam [7:0] SELECT_APDU_5  = 8'h04;
localparam [7:0] SELECT_APDU_6  = 8'h00;
localparam [7:0] SELECT_APDU_7  = 8'h10;
localparam [7:0] SELECT_APDU_8  = 8'hA0;
localparam [7:0] SELECT_APDU_9  = 8'h00;
localparam [7:0] SELECT_APDU_10 = 8'h00;
localparam [7:0] SELECT_APDU_11 = 8'h03;
localparam [7:0] SELECT_APDU_12 = 8'h96;
localparam [7:0] SELECT_APDU_13 = 8'h54;
localparam [7:0] SELECT_APDU_14 = 8'h53;
localparam [7:0] SELECT_APDU_15 = 8'h00;
localparam [7:0] SELECT_APDU_16 = 8'h00;
localparam [7:0] SELECT_APDU_17 = 8'h00;
localparam [7:0] SELECT_APDU_18 = 8'h01;
localparam [7:0] SELECT_APDU_19 = 8'h03;
localparam [7:0] SELECT_APDU_20 = 8'h00;
localparam [7:0] SELECT_APDU_21 = 8'h00;
localparam [7:0] SELECT_APDU_22 = 8'h00;
localparam [7:0] SELECT_APDU_23 = 8'h00;
localparam [7:0] SELECT_APDU_24 = 8'h00;
localparam [7:0] SELECT_APDU_25 = 8'hA8;
localparam [7:0] SELECT_APDU_26 = 8'hC8;

localparam [7:0] RESYNC_APDU_0 = 8'h5A;
localparam [7:0] RESYNC_APDU_1 = 8'hC0;
localparam [7:0] RESYNC_APDU_2 = 8'h00;
localparam [7:0] RESYNC_APDU_3 = 8'hFF;
localparam [7:0] RESYNC_APDU_4 = 8'hFC;

localparam [7:0] GET_ATR_0 = 8'h5A;
localparam [7:0] GET_ATR_1 = 8'hC7;
localparam [7:0] GET_ATR_2 = 8'h00;
localparam [7:0] GET_ATR_3 = 8'hF7;
localparam [7:0] GET_ATR_4 = 8'hB1;

localparam [7:0] HASH_0  = 8'h5A;
localparam [7:0] HASH_1  = 8'h40;
localparam [7:0] HASH_2  = 8'h2D;
localparam [7:0] HASH_3  = 8'h80;
localparam [7:0] HASH_4  = 8'h03;
localparam [7:0] HASH_5  = 8'h00;
localparam [7:0] HASH_6  = 8'h0E;
localparam [7:0] HASH_7  = 8'h27;
localparam [7:0] HASH_8  = 8'h41;
localparam [7:0] HASH_9  = 8'h01;
localparam [7:0] HASH_10 = 8'h04;
localparam [7:0] HASH_11 = 8'h42;
localparam [7:0] HASH_12 = 8'h22;
localparam [7:0] HASH_13 = 8'h48;
localparam [7:0] HASH_14 = 8'h65;
localparam [7:0] HASH_15 = 8'h6C;
localparam [7:0] HASH_16 = 8'h6C;
localparam [7:0] HASH_17 = 8'h6F;
localparam [7:0] HASH_18 = 8'h2C;
localparam [7:0] HASH_19 = 8'h20;
localparam [7:0] HASH_20 = 8'h74;
localparam [7:0] HASH_21 = 8'h68;
localparam [7:0] HASH_22 = 8'h69;
localparam [7:0] HASH_23 = 8'h73;
localparam [7:0] HASH_24 = 8'h20;
localparam [7:0] HASH_25 = 8'h69;
localparam [7:0] HASH_26 = 8'h73;
localparam [7:0] HASH_27 = 8'h20;
localparam [7:0] HASH_28 = 8'h61;
localparam [7:0] HASH_29 = 8'h20;
localparam [7:0] HASH_30 = 8'h74;
localparam [7:0] HASH_31 = 8'h65;
localparam [7:0] HASH_32 = 8'h73;
localparam [7:0] HASH_33 = 8'h74;
localparam [7:0] HASH_34 = 8'h20;
localparam [7:0] HASH_35 = 8'h64;
localparam [7:0] HASH_36 = 8'h61;
localparam [7:0] HASH_37 = 8'h74;
localparam [7:0] HASH_38 = 8'h61;
localparam [7:0] HASH_39 = 8'h20;
localparam [7:0] HASH_40 = 8'h73;
localparam [7:0] HASH_41 = 8'h74;
localparam [7:0] HASH_42 = 8'h72;
localparam [7:0] HASH_43 = 8'h69;
localparam [7:0] HASH_44 = 8'h6E;
localparam [7:0] HASH_45 = 8'h67;
localparam [7:0] HASH_46 = 8'h21;
localparam [7:0] HASH_47 = 8'h00;
localparam [7:0] HASH_48 = 8'hB0; //TODO:: generate CRC
localparam [7:0] HASH_49 = 8'h7D;

localparam [7:0] SIGN_0 = 8'h5A;
localparam [7:0] SIGN_1 = 8'h00;
localparam [7:0] SIGN_2 = 8'h31;
localparam [7:0] SIGN_3 = 8'h80;
localparam [7:0] SIGN_4 = 8'h03;
localparam [7:0] SIGN_5 = 8'h0C;
localparam [7:0] SIGN_6 = 8'h09;
localparam [7:0] SIGN_7 = 8'h2B;
localparam [7:0] SIGN_8 = 8'h41;
localparam [7:0] SIGN_9 = 8'h04;
localparam [7:0] SIGN_10 = 8'hF0;
localparam [7:0] SIGN_11 = 8'h00;
localparam [7:0] SIGN_12 = 8'h01;
localparam [7:0] SIGN_13 = 8'h02;
localparam [7:0] SIGN_14 = 8'h42;
localparam [7:0] SIGN_15 = 8'h01;
localparam [7:0] SIGN_16 = 8'h21;
localparam [7:0] SIGN_17 = 8'h43;
localparam [7:0] SIGN_18 = 8'h20;
localparam [7:0] SIGN_19 = 8'h6E;
localparam [7:0] SIGN_20 = 8'hAC;
localparam [7:0] SIGN_21 = 8'h20;
localparam [7:0] SIGN_22 = 8'hD0;
localparam [7:0] SIGN_23 = 8'h56;
localparam [7:0] SIGN_24 = 8'h67;
localparam [7:0] SIGN_25 = 8'hA8;
localparam [7:0] SIGN_26 = 8'h7A;
localparam [7:0] SIGN_27 = 8'hEB;
localparam [7:0] SIGN_28 = 8'hF7;
localparam [7:0] SIGN_29 = 8'hAB;
localparam [7:0] SIGN_30 = 8'h5A;
localparam [7:0] SIGN_31 = 8'h1C;
localparam [7:0] SIGN_32 = 8'hAB;
localparam [7:0] SIGN_33 = 8'h0C;
localparam [7:0] SIGN_34 = 8'h36;
localparam [7:0] SIGN_35 = 8'h7E;
localparam [7:0] SIGN_36 = 8'hFA;
localparam [7:0] SIGN_37 = 8'hE1;
localparam [7:0] SIGN_38 = 8'h4F;
localparam [7:0] SIGN_39 = 8'hCF;
localparam [7:0] SIGN_40 = 8'h0D;
localparam [7:0] SIGN_41 = 8'hB8;
localparam [7:0] SIGN_42 = 8'hEF;
localparam [7:0] SIGN_43 = 8'h4A;
localparam [7:0] SIGN_44 = 8'hF2;
localparam [7:0] SIGN_45 = 8'h34;
localparam [7:0] SIGN_46 = 8'hD8;
localparam [7:0] SIGN_47 = 8'h77;
localparam [7:0] SIGN_48 = 8'h64;
localparam [7:0] SIGN_49 = 8'hC8;
localparam [7:0] SIGN_50 = 8'h63;
localparam [7:0] SIGN_51 = 8'h00;
localparam [7:0] SIGN_52 = 8'hFC;
localparam [7:0] SIGN_53 = 8'h6A;


//Taken from page 14 of ADT7420
// Bit 7: 1 for 16 bit, Bit 6:5, 00 Continuous conversion, Bit 4 Comparator or interrupt mode (doesn't matter) Bit 3 Polarity of INT (Doesn't matter), Bit 2 Polarity of CT, Bit 1:0 11, 4 faults
localparam [7:0] CONFIG_BITS = 8'b10000011;

//State machine for ADT7420 and SE050
localparam [4:0] SETUP        = 5'd0,
                 VERIFY_ID    = 5'd1,
                 WRITE_CONFIG = 5'd2,
                 WRITE_REQ    = 5'd3,
                 WRITE_FINISH = 5'd4,
                 TEMP_DATA_AQ = 5'd5,
                 READ_REQ     = 5'd6,
                 AWAIT_DATA   = 5'd7,
                 INCR_DATA_AQ = 5'd8,
                 ERROR        = 5'd9,
                 SE_SETUP     = 5'd10,
                 SE_WRITE_REQ = 5'd11,
                 SE_AWAIT_ACK = 5'd12,
                 SE_READ_SETUP = 5'd13,
                 SE_READ_REQ  = 5'd14,
                 SE_READ_AWAIT = 5'd15,
                 SE_READ_FINISH = 5'd16,
                 SE_FINISH    = 5'd17,
                 SE_ERROR     = 5'd18,
                 SE_START     = 5'd19,
                 SE_DONE      = 5'd20,
                 SE_RESYNC_READ       = 5'd21,
                 SE_RESYNC_2_SETUP    = 5'd22,
                 SE_RESYNC_2_READ     = 5'd23,
                 SE_GET_ATR_SETUP     = 5'd24,
                 SE_GET_ATR_READ      = 5'd25,
                 SE_SELECT_APDU_SETUP = 5'd26,
                 SE_SELECT_APDU_READ  = 5'd27,
                 SE_HASH_SETUP        = 5'd28,
                 SE_HASH_READ         = 5'd29,
                 SE_SIGN_SETUP        = 5'd30,
                 SE_SIGN_READ         = 5'd31,
                 SE_END_WAIT          = 6'd32;
                 
localparam [3:0] RESYNC       = 4'd1,
                 RESYNC_2     = 4'd2,
                 GET_ATR      = 4'd3,
                 SELECT_APDU  = 4'd4,
                 HASH         = 4'd5,
                 SIGN         = 4'd6;
                 

//Internal registers
reg [5:0 ] state;
reg [5:0 ] next_state;
reg [7:0 ] data_read;
reg [15:0] temp_data;
reg        en_cntr;
reg [31:0] cntr;
reg [23:0] read_bytes;
reg        temp_data_read;
reg [7:0 ] apdu_index;
reg [3:0 ] read_index;
reg [3:0 ] current_msg;

//For I2C Master
reg  [7:0]  slave_addr;
reg  [15:0] i_sub_addr;
reg         i_sub_len;
reg  [23:0] i_byte_len;
reg  [7:0]  i_data_write;
reg         request_transmit;
wire [7:0]  data_out;
wire        valid_out;
wire        req_data_chunk;
wire        busy;
wire        nack;

//For SE050 I2C Master
reg  [7:0]  se_slave_addr;
reg  [15:0] se_i_sub_addr;
reg         se_i_sub_len;
reg  [23:0] se_i_byte_len;
reg  [7:0]  se_i_data_write;
reg         se_request_transmit;
wire [7:0]  se_data_out;
wire        se_valid_out;
wire        se_req_data_chunk;
wire        se_busy;
wire        se_nack;
reg  [31:0]  delay_counter;
reg  [31:0]  delay_tgt;

//For driving 7SEG display
reg [19:0] SSEG_data;
reg temp_displayed;

//State machine for ADT7420 and SE050
always@(posedge clk or negedge rst) begin
    if (!rst) begin
        //For internal regs
        state <= SETUP; // Start with the temperature reading routine
        next_state <= SETUP;
        {read_bytes, data_read, temp_data_read} <= 0;
        {cntr, en_cntr} <= 0;
        SSEG_data <= 0;
        apdu_index <= 8'd0;
        read_index <= 8'd0;
    end else begin
        cntr <= en_cntr ? cntr + 1 : 0;
        temp_data_read <= 0;
        
        case(state)
            // Initial setup for temperature reading
            SETUP: begin
                temp_displayed <= 1'b0;
                slave_addr <= {I2C_ADDR, 1'b1};     // LSB denotes read
                i_sub_addr <= 16'h0B;               // Register address is 0x0B for Device ID
                i_sub_len <= 1'b0;                  // Denotes reg addr is 8 bit
                i_byte_len <= 23'd1;                // Denotes 1 byte to read
                i_data_write <= 8'b0;               // Nothing to write, this is a read
                state <= READ_REQ;
                next_state <= VERIFY_ID;
                request_transmit <= 1'b1;
            end
            
            VERIFY_ID: begin
                if(data_read == DEVICE_ID) begin
                    state <= WRITE_CONFIG;
                end else begin
                    state <= ERROR;
                end
                SSEG_data <= {8'h1D, 4'b0, data_read};
            end
            
            WRITE_CONFIG: begin
                slave_addr <= {I2C_ADDR, 1'b0};     // LSB denotes write
                i_sub_addr <= 16'h03;               // Register address is 0x03 for Configuration register
                i_sub_len <= 1'b0;                  // Denotes reg addr is 8 bit
                i_byte_len <= 23'd1;                // Denotes 1 byte to write
                i_data_write <= CONFIG_BITS;        // Write our premade configuration register for what we want
                request_transmit <= 1'b1;
                state <= WRITE_REQ;
                next_state <= WRITE_FINISH;
            end
            
            WRITE_REQ: begin
                if(busy) begin
                    state <= WRITE_FINISH;
                    request_transmit <= 1'b0;
                end
            end
            
            WRITE_FINISH: begin
                if(!busy) begin
                    state <= TEMP_DATA_AQ;
                    en_cntr <= 1'b1;
                end
            end
            
            TEMP_DATA_AQ: begin
                if(cntr == 100_000_000 && !temp_displayed) begin // 1 sec delay
                    en_cntr <= 1'b0;
                    slave_addr <= {I2C_ADDR, 1'b1};     // LSB denotes read
                    i_sub_addr <= 16'h00;               // Register address is 0x00 for MSB of temperature
                    i_sub_len <= 1'b0;                  // Denotes reg addr is 8 bit
                    i_byte_len <= 23'd2;                // Denotes 2 bytes to read
                    i_data_write <= 8'b0;               // Nothing to write, this is a read
                    state <= READ_REQ;
                    next_state <= INCR_DATA_AQ;
                    request_transmit <= 1'b1;
                    read_bytes <= 0;
                    SSEG_data <= temp_data[15] ? ((~temp_data) + 1) / 128 : temp_data / 128;  // Note here want bitwise not(~), not logical not(!), since we want to take 2's complement
                    temp_displayed <= 1;
                end else begin 
                    state <= SE_SETUP;
                end
            end
            
            READ_REQ: begin
                //SSEG_data <= 20'h000F1;
                if(busy) begin
                    state <= AWAIT_DATA;
                    request_transmit <= 1'b0;
                end
            end
            
            AWAIT_DATA: begin
                //SSEG_data <= 20'h00FF1;
                if(valid_out) begin
                    state <= next_state;
                    data_read <= data_out;
                end
            end
            
            INCR_DATA_AQ: begin
                if(read_bytes == i_byte_len - 1) begin
                    state <= TEMP_DATA_AQ;
                    temp_data_read <= 1'b1;
                    en_cntr <= 1'b1;
                end else begin
                    read_bytes <= read_bytes + 1;
                    state <= AWAIT_DATA;
                end
                temp_data[(1 - read_bytes) * 8 +: 8] <= data_read;
            end
            
            // SE050 routine starts here
            SE_SETUP: begin
                temp_displayed <= 1'b0;
                SSEG_data <= 20'h00001;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_sub_addr <= 16'h00;                 // No sub-address for APDU
                se_i_sub_len <= 1'b0;                    // No sub-address length
                se_i_byte_len <= 23'd5;                  // Length of each APDU in bytes
                current_msg <= RESYNC;
                se_i_data_write <= RESYNC_APDU_0;
                apdu_index <= 8'd1;                      // Start with the second byte
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                read_index <= 0;
            end
            
            SE_RESYNC_2_SETUP: begin
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_byte_len <= 23'd5;             // Number of bytes
                current_msg <= RESYNC_2;           // What message are we sending
                se_i_data_write <= RESYNC_APDU_0;   // First byte
                apdu_index <= 8'd1;                 // Set apdu index
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                SSEG_data <= 20'h00002;
                read_index <= 0;
            end
            
            // State for GET_ATR
            SE_GET_ATR_SETUP: begin
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_byte_len <= 23'd5;             // Number of bytes
                current_msg <= GET_ATR;             // What message are we sending
                se_i_data_write <= GET_ATR_0;       // First byte
                apdu_index <= 8'd1;                 // Set apdu index
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                SSEG_data <= 20'h00003;
                read_index <= 0;
            end
            
            // State for SELECT_APDU
            SE_SELECT_APDU_SETUP: begin
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_byte_len <= 23'd27;            // Number of bytes
                current_msg <= SELECT_APDU;         // What message are we sending
                se_i_data_write <= SELECT_APDU_0;   // First byte
                apdu_index <= 8'd1;                 // Set apdu index
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                SSEG_data <= 20'h00004;
                read_index <= 0;
            end
            
            // State for HASH
            SE_HASH_SETUP: begin
                SSEG_data <= 20'h00005;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_byte_len <= 23'd50;            // Number of bytes
                current_msg <= HASH;                // What message are we sending
                se_i_data_write <= HASH_0;          // First byte
                apdu_index <= 8'd1;                 // Set apdu index
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                read_index <= 0;
            end
            
            // State for SIGN
            SE_SIGN_SETUP: begin
                se_slave_addr <= {SE050_I2C_ADDR, 1'b0}; // Write operation
                se_i_byte_len <= 23'd54;            // Number of bytes
                current_msg <= SIGN;                // What message are we sending
                se_i_data_write <= SIGN_0;          // First byte
                apdu_index <= 8'd1;                 // Set apdu index
                state <= SE_WRITE_REQ;
                se_request_transmit <= 1'b1;
                read_index <= 0;
            end
            
            SE_WRITE_REQ: begin
                SSEG_data <= 20'h00007;
                if(se_busy) begin
                    state <= SE_AWAIT_ACK;
                    se_request_transmit <= 1'b0;
                end
            end
            
            SE_AWAIT_ACK: begin
                SSEG_data <= 20'h00008;
                if (se_req_data_chunk) begin
                    case (current_msg)
                        RESYNC: begin
                            if(apdu_index < 8'd5) begin  // Adjust to send all bytes of the Resync APDU
                                case(apdu_index) //NOTE - switched these to literals during testing. think we can switch back, but remember to verify if you do.
                                    4'd0: se_i_data_write <= RESYNC_APDU_0;
                                    4'd1: se_i_data_write <= RESYNC_APDU_1;
                                    4'd2: se_i_data_write <= RESYNC_APDU_2;
                                    4'd3: se_i_data_write <= RESYNC_APDU_3;
                                    4'd4: se_i_data_write <= RESYNC_APDU_4;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                        
                        RESYNC_2: begin
                            if(apdu_index < 8'd5) begin  // Adjust to send all bytes of the Resync APDU
                                
                                case(apdu_index) //NOTE - switched these to literals during testing. think we can switch back, but remember to verify if you do.
                                    4'd0: se_i_data_write <= RESYNC_APDU_0;
                                    4'd1: se_i_data_write <= RESYNC_APDU_1;
                                    4'd2: se_i_data_write <= RESYNC_APDU_2;
                                    4'd3: se_i_data_write <= RESYNC_APDU_3;
                                    4'd4: se_i_data_write <= RESYNC_APDU_4;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                        
                        GET_ATR: begin
                            if(apdu_index < 8'd5) begin  // Adjust to send all bytes of the GET_ATR
                                case(apdu_index)
                                    4'd0: se_i_data_write <= GET_ATR_0;
                                    4'd1: se_i_data_write <= GET_ATR_1;
                                    4'd2: se_i_data_write <= GET_ATR_2;
                                    4'd3: se_i_data_write <= GET_ATR_3;
                                    4'd4: se_i_data_write <= GET_ATR_4;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                        
                        SELECT_APDU: begin
                            if(apdu_index < 8'd27) begin  // Adjust to send all bytes of the SELECT_APDU
                                case(apdu_index)
                                    5'd0:  se_i_data_write <= SELECT_APDU_0;
                                    5'd1:  se_i_data_write <= SELECT_APDU_1;
                                    5'd2:  se_i_data_write <= SELECT_APDU_2;
                                    5'd3:  se_i_data_write <= SELECT_APDU_3;
                                    5'd4:  se_i_data_write <= SELECT_APDU_4;
                                    5'd5:  se_i_data_write <= SELECT_APDU_5;
                                    5'd6:  se_i_data_write <= SELECT_APDU_6;
                                    5'd7:  se_i_data_write <= SELECT_APDU_7;
                                    5'd8:  se_i_data_write <= SELECT_APDU_8;
                                    5'd9:  se_i_data_write <= SELECT_APDU_9;
                                    5'd10: se_i_data_write <= SELECT_APDU_10;
                                    5'd11: se_i_data_write <= SELECT_APDU_11;
                                    5'd12: se_i_data_write <= SELECT_APDU_12;
                                    5'd13: se_i_data_write <= SELECT_APDU_13;
                                    5'd14: se_i_data_write <= SELECT_APDU_14;
                                    5'd15: se_i_data_write <= SELECT_APDU_15;
                                    5'd16: se_i_data_write <= SELECT_APDU_16;
                                    5'd17: se_i_data_write <= SELECT_APDU_17;
                                    5'd18: se_i_data_write <= SELECT_APDU_18;
                                    5'd19: se_i_data_write <= SELECT_APDU_19;
                                    5'd20: se_i_data_write <= SELECT_APDU_20;
                                    5'd21: se_i_data_write <= SELECT_APDU_21;
                                    5'd22: se_i_data_write <= SELECT_APDU_22;
                                    5'd23: se_i_data_write <= SELECT_APDU_23;
                                    5'd24: se_i_data_write <= SELECT_APDU_24;
                                    5'd25: se_i_data_write <= SELECT_APDU_25;
                                    5'd26: se_i_data_write <= SELECT_APDU_26;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                        
                        HASH: begin
                            if(apdu_index < 8'd50) begin  // Adjust to send all bytes of the HASH
                                case(apdu_index)
                                    6'd0:  se_i_data_write <= HASH_0;
                                    6'd1:  se_i_data_write <= HASH_1;
                                    6'd2:  se_i_data_write <= HASH_2;
                                    6'd3:  se_i_data_write <= HASH_3;
                                    6'd4:  se_i_data_write <= HASH_4;
                                    6'd5:  se_i_data_write <= HASH_5;
                                    6'd6:  se_i_data_write <= HASH_6;
                                    6'd7:  se_i_data_write <= HASH_7;
                                    6'd8:  se_i_data_write <= HASH_8;
                                    6'd9:  se_i_data_write <= HASH_9;
                                    6'd10: se_i_data_write <= HASH_10;
                                    6'd11: se_i_data_write <= HASH_11;
                                    6'd12: se_i_data_write <= HASH_12;
                                    6'd13: se_i_data_write <= HASH_13;
                                    6'd14: se_i_data_write <= HASH_14;
                                    6'd15: se_i_data_write <= HASH_15;
                                    6'd16: se_i_data_write <= HASH_16;
                                    6'd17: se_i_data_write <= HASH_17;
                                    6'd18: se_i_data_write <= HASH_18;
                                    6'd19: se_i_data_write <= HASH_19;
                                    6'd20: se_i_data_write <= HASH_20;
                                    6'd21: se_i_data_write <= HASH_21;
                                    6'd22: se_i_data_write <= HASH_22;
                                    6'd23: se_i_data_write <= HASH_23;
                                    6'd24: se_i_data_write <= HASH_24;
                                    6'd25: se_i_data_write <= HASH_25;
                                    6'd26: se_i_data_write <= HASH_26;
                                    6'd27: se_i_data_write <= HASH_27;
                                    6'd28: se_i_data_write <= HASH_28;
                                    6'd29: se_i_data_write <= HASH_29;
                                    6'd30: se_i_data_write <= HASH_30;
                                    6'd31: se_i_data_write <= HASH_31;
                                    6'd32: se_i_data_write <= HASH_32;
                                    6'd33: se_i_data_write <= HASH_33;
                                    6'd34: se_i_data_write <= HASH_34;
                                    6'd35: se_i_data_write <= HASH_35;
                                    6'd36: se_i_data_write <= HASH_36;
                                    6'd37: se_i_data_write <= HASH_37;
                                    6'd38: se_i_data_write <= HASH_38;
                                    6'd39: se_i_data_write <= HASH_39;
                                    6'd40: se_i_data_write <= HASH_40;
                                    6'd41: se_i_data_write <= HASH_41;
                                    6'd42: se_i_data_write <= HASH_42;
                                    6'd43: se_i_data_write <= HASH_43;
                                    6'd44: se_i_data_write <= HASH_44;
                                    6'd45: se_i_data_write <= HASH_45;
                                    6'd46: se_i_data_write <= HASH_46;
                                    6'd47: se_i_data_write <= HASH_47;
                                    6'd48: se_i_data_write <= HASH_48;
                                    6'd49: se_i_data_write <= HASH_49;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                        
                        SIGN: begin
                            if(apdu_index < 8'd54) begin  // Adjust to send all bytes of the SIGN
                                case(apdu_index)
                                    6'd0:  se_i_data_write <= SIGN_0;
                                    6'd1:  se_i_data_write <= SIGN_1;
                                    6'd2:  se_i_data_write <= SIGN_2;
                                    6'd3:  se_i_data_write <= SIGN_3;
                                    6'd4:  se_i_data_write <= SIGN_4;
                                    6'd5:  se_i_data_write <= SIGN_5;
                                    6'd6:  se_i_data_write <= SIGN_6;
                                    6'd7:  se_i_data_write <= SIGN_7;
                                    6'd8:  se_i_data_write <= SIGN_8;
                                    6'd9:  se_i_data_write <= SIGN_9;
                                    6'd10: se_i_data_write <= SIGN_10;
                                    6'd11: se_i_data_write <= SIGN_11;
                                    6'd12: se_i_data_write <= SIGN_12;
                                    6'd13: se_i_data_write <= SIGN_13;
                                    6'd14: se_i_data_write <= SIGN_14;
                                    6'd15: se_i_data_write <= SIGN_15;
                                    6'd16: se_i_data_write <= SIGN_16;
                                    6'd17: se_i_data_write <= SIGN_17;
                                    6'd18: se_i_data_write <= SIGN_18;
                                    6'd19: se_i_data_write <= SIGN_19;
                                    6'd20: se_i_data_write <= SIGN_20;
                                    6'd21: se_i_data_write <= SIGN_21;
                                    6'd22: se_i_data_write <= SIGN_22;
                                    6'd23: se_i_data_write <= SIGN_23;
                                    6'd24: se_i_data_write <= SIGN_24;
                                    6'd25: se_i_data_write <= SIGN_25;
                                    6'd26: se_i_data_write <= SIGN_26;
                                    6'd27: se_i_data_write <= SIGN_27;
                                    6'd28: se_i_data_write <= SIGN_28;
                                    6'd29: se_i_data_write <= SIGN_29;
                                    6'd30: se_i_data_write <= SIGN_30;
                                    6'd31: se_i_data_write <= SIGN_31;
                                    6'd32: se_i_data_write <= SIGN_32;
                                    6'd33: se_i_data_write <= SIGN_33;
                                    6'd34: se_i_data_write <= SIGN_34;
                                    6'd35: se_i_data_write <= SIGN_35;
                                    6'd36: se_i_data_write <= SIGN_36;
                                    6'd37: se_i_data_write <= SIGN_37;
                                    6'd38: se_i_data_write <= SIGN_38;
                                    6'd39: se_i_data_write <= SIGN_39;
                                    6'd40: se_i_data_write <= SIGN_40;
                                    6'd41: se_i_data_write <= SIGN_41;
                                    6'd42: se_i_data_write <= SIGN_42;
                                    6'd43: se_i_data_write <= SIGN_43;
                                    6'd44: se_i_data_write <= SIGN_44;
                                    6'd45: se_i_data_write <= SIGN_45;
                                    6'd46: se_i_data_write <= SIGN_46;
                                    6'd47: se_i_data_write <= SIGN_47;
                                    6'd48: se_i_data_write <= SIGN_48;
                                    6'd49: se_i_data_write <= SIGN_49;
                                    6'd50: se_i_data_write <= SIGN_50;
                                    6'd51: se_i_data_write <= SIGN_51;
                                    6'd52: se_i_data_write <= SIGN_52;
                                    6'd53: se_i_data_write <= SIGN_53;
                                endcase
                                apdu_index <= apdu_index + 1;
                            end
                        end
                    endcase
                end 
                if(!se_busy) begin
                    // Check for ACK/NACK after each byte sent
                    if (se_nack) begin
                        state <= SE_ERROR; // Go to error state if NACK received
                    end else begin
                        read_index <= 4'd0;
                        case (current_msg)
                            RESYNC: begin
                                if(apdu_index >= 8'd5) begin
                                    next_state <= SE_RESYNC_READ;
                                    delay_tgt <= 4_000_000; //10ms
                                end
                            end
                            
                            RESYNC_2: begin
                                if(apdu_index >= 8'd5) begin
                                    next_state <= SE_RESYNC_2_READ;
                                    delay_tgt <= 4_000_000; //10ms
                                end
                            end
                            
                            GET_ATR: begin
                                if(apdu_index >= 8'd5) begin
                                    next_state <= SE_GET_ATR_READ;
                                    delay_tgt <= 4_000_000; //10ms
                                end
                            end
                            
                            SELECT_APDU: begin
                                next_state <= SE_SELECT_APDU_READ;
                                delay_tgt <= 4_000_000; //20ms
                            end
                             
                            HASH: begin
                                next_state <= SE_HASH_READ;
                                delay_tgt <= 4_000_000; //20ms
                            end
                            
                            SIGN: begin
                                next_state <= SE_SIGN_READ;
                                delay_tgt <= 10_000_000; //50ms
                            end
                        endcase
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                    end
                end
            end
            
            //TODO:: think we want to throw something in here like delay_tgt so we can use the same state to wait for commands of arbitrary time to complete
            SE_END_WAIT:begin
                if (delay_counter == delay_tgt) begin 
                    state <= next_state;
                end else begin
                    delay_counter <= delay_counter + 1;
                end
            end

            SE_RESYNC_READ:begin
                SSEG_data <= 20'h00009;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2;
                        next_state <= SE_RESYNC_READ;
                        state <= SE_READ_REQ;
                        read_index <= 4'd1;
                        se_i_data_write <= 8'd0;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_RESYNC_READ;
                        state <= SE_READ_REQ;
                        se_i_byte_len <= 23'd1;
                        read_index <= 4'd2;
                        se_i_data_write <= 8'd0;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_RESYNC_READ;
                        state <= SE_READ_REQ;
                        se_i_byte_len <= 23'd255;
                        read_index <= 4'd3;
                        se_i_data_write <= 8'd0;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_RESYNC_2_SETUP;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end
            
            //TODO:: follow same thing for all states where state is set at top and then at last case it goes to wait
            SE_RESYNC_2_READ:begin
                SSEG_data <= 20'h00010;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2;
                        next_state <= SE_RESYNC_2_READ;
                        read_index <= 4'd1;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_RESYNC_2_READ;
                        se_i_byte_len <= 23'd1;
                        read_index <= 4'd2;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_RESYNC_2_READ;
                        se_i_byte_len <= 23'd255;
                        read_index <= 4'd3;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_GET_ATR_SETUP;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end    
            
            SE_GET_ATR_READ:begin
                SSEG_data <= 20'h00011;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2; //dir + error
                        next_state <= SE_GET_ATR_READ;
                        read_index <= 4'd1;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_GET_ATR_READ;
                        se_i_byte_len <= 23'd1; //len
                        read_index <= 4'd2;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_GET_ATR_READ;
                        se_i_byte_len <= 23'd35; //data
                        read_index <= 4'd3;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_GET_ATR_READ;
                        se_i_byte_len <= 23'd2;  //CRC
                        read_index <= 4'd4;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd4: begin
                        next_state <= SE_SELECT_APDU_SETUP;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end   
            
            SE_SELECT_APDU_READ:begin
                SSEG_data <= 20'h00012;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2;
                        next_state <= SE_SELECT_APDU_READ;
                        read_index <= 4'd1;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_SELECT_APDU_READ;
                        se_i_byte_len <= 23'd1;
                        read_index <= 4'd2;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_SELECT_APDU_READ;
                        se_i_byte_len <= 23'd9; 
                        read_index <= 4'd3;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_SELECT_APDU_READ;
                        se_i_byte_len <= 23'd2; //crc
                        read_index <= 4'd4;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd4: begin
                        next_state <= SE_HASH_SETUP;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end   
            
            SE_HASH_READ:begin
                SSEG_data <= 20'h00013;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2;
                        next_state <= SE_HASH_READ;
                        read_index <= 4'd1;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_HASH_READ;
                        se_i_byte_len <= 23'd1;
                        read_index <= 4'd2;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_HASH_READ;
                        se_i_byte_len <= 23'd38; 
                        read_index <= 4'd3;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_HASH_READ;
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd4;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd4: begin
                        next_state <= SE_SIGN_SETUP;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end
            
            SE_SIGN_READ:begin
                SSEG_data <= 20'h00006;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                case (read_index)
                    4'd0: begin
                        se_i_byte_len <= 23'd2;
                        next_state <= SE_SIGN_READ;
                        read_index <= 4'd1;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd1: begin
                        next_state <= SE_SIGN_READ;
                        se_i_byte_len <= 23'd1;
                        read_index <= 4'd2;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd2: begin
                        next_state <= SE_SIGN_READ;
                        se_i_byte_len <= 23'd0;
                        se_i_byte_len <= data_read;
                        read_index <= 4'd3;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd3: begin
                        next_state <= SE_SIGN_READ;
                        se_i_byte_len <= 23'd2;//crc
                        read_index <= 4'd4;
                        state <= SE_READ_REQ;
                        se_request_transmit <= 1'b1;
                    end
                    4'd4: begin
                        next_state <= SE_DONE;
                        state <= SE_END_WAIT;
                        delay_counter <= 0;
                        delay_tgt <= 50_000; //500 us
                        se_i_byte_len <= 23'd2;
                        read_index <= 4'd0;
                    end
                endcase
            end
            
            SE_READ_SETUP: begin
                SSEG_data <= 8'h88;
                se_slave_addr <= {SE050_I2C_ADDR, 1'b1}; // Read operation
                se_i_sub_addr <= 16'h00; // No sub-address for APDU response
                se_i_sub_len <= 1'b0; // No sub-address length
                se_i_byte_len <= 23'd255; // Length of the response (adjust as needed)
                state <= SE_READ_REQ;
                se_request_transmit <= 1'b1;
            end
            
            SE_READ_REQ: begin
                SSEG_data <= 8'h89;
                if(se_busy) begin
                    state <= SE_READ_AWAIT;
                    se_request_transmit <= 1'b0;
                end
            end
            
            //TODO:: wait another 10ms if stuck here
            SE_READ_AWAIT: begin
                SSEG_data <= 8'h8A;
                if(se_valid_out) begin
                    state <= SE_READ_FINISH;
                    data_read <= se_data_out; // Store the read data
                end
            end
            
            SE_READ_FINISH: begin
                SSEG_data <= 8'h8B;
                if(!se_busy) begin
                    SSEG_data <= data_read; // Display the MSB of the result on the 7-segment display
                    state <= next_state;
                end
            end 
            
            ERROR: begin
                SSEG_data <= 20'hE7707;   // Error without having to put in an R
            end
            
            SE_ERROR: begin
                SSEG_data <= 20'hE7708; // Error state for SE050
            end
            
            SE_DONE: begin
                SSEG_data <= 20'h12345;
                delay_tgt <= 100_000_000;
                next_state <= SE_SETUP;
                state <= SE_END_WAIT;
            end
            
            default:
                state <= SE_SETUP;
        endcase
        
        //Error checking
        if(busy & nack) begin
            state <= ERROR;
        end
        if(se_busy & se_nack) begin
            state <= SE_ERROR;
        end
    end
end

//Instantiate daughter modules 
i2c_master i_i2c_master(
    .i_clk(clk),                    //input clock to the module @100MHz (or whatever crystal you have on the board)
    .reset_n(rst),                  //reset for creating a known start condition
    .i_addr_w_rw(slave_addr),       //7 bit address, LSB is the read write bit, with 0 being write, 1 being read
    .i_sub_addr(i_sub_addr),        //contains sub addr to send to slave, partition is decided on bit_sel
    .i_sub_len(i_sub_len),          //denotes whether working with an 8 bit or 16 bit sub_addr, 0 is 8bit, 1 is 16 bit
    .i_byte_len(i_byte_len),        //denotes whether a single or sequential read or write will be performed (denotes number of bytes to read or write)
    .i_data_write(i_data_write),    //Data to write if performing write action
    .req_trans(request_transmit),   //denotes when to start a new transaction
    .requires_sub_addr(1'b1),       // Temperature sensor requires sub-address


    /** For Reads **/
    .data_out(data_out),
    .valid_out(valid_out),

    /** I2C Lines **/
    .scl_o(scl),                //i2c clck line, output by this module, 400 kHz
    .sda_o(sda),                //i2c data line, set to 1'bz when not utilized (resistors will pull it high)

    /** Comms to Master Module **/
    .req_data_chunk(req_data_chunk),//Request master to send new data chunk in i_data_write
    .busy(busy),                    //denotes whether module is currently communicating with a slave
    .nack(nack)
);

//Instantiate SE050 I2C Master Module
i2c_master i_se050_i2c_master(
    .i_clk(clk),                    //input clock to the module @100MHz (or whatever crystal you have on the board)
    .reset_n(rst),                  //reset for creating a known start condition
    .i_addr_w_rw(se_slave_addr),    //7 bit address, LSB is the read write bit, with 0 being write, 1 being read
    .i_sub_addr(se_i_sub_addr),     //contains sub addr to send to slave, partition is decided on bit_sel
    .i_sub_len(se_i_sub_len),       //denotes whether working with an 8 bit or 16 bit sub_addr, 0 is 8bit, 1 is 16 bit
    .i_byte_len(se_i_byte_len),     //denotes whether a single or sequential read or write will be performed (denotes number of bytes to read or write)
    .i_data_write(se_i_data_write), //Data to write if performing write action
    .req_trans(se_request_transmit),//denotes when to start a new transaction
    .requires_sub_addr(1'b0),       // SE requires NO sub-address


    /** For Reads **/
    .data_out(se_data_out),
    .valid_out(se_valid_out),

    /** I2C Lines **/
    .scl_o(se_scl),                 //i2c clck line, output by this module, 400 kHz
    .sda_o(se_sda),                 //i2c data line, set to 1'bz when not utilized (resistors will pull it high)

    /** Comms to Master Module **/
    .req_data_chunk(se_req_data_chunk),//Request master to send new data chunk in i_data_write
    .busy(se_busy),                 //denotes whether module is currently communicating with a slave
    .nack(se_nack)
);

SSEG i_SSEG(
    .clk(clk),
    .rst(rst),
    .data(SSEG_data), 
    .anode(anode), 
    ._7LED(_7LED)
);

endmodule