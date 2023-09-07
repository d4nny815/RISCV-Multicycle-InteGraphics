`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: J. Callenes, P. Hummel
//
// Create Date: 01/27/2019 08:37:11 AM
// Module Name: OTTER_mem
// Project Name: Memory for OTTER RV32I RISC-V
// Tool Versions: Xilinx Vivado 2019.2
// Description: 64k Memory, dual access read single access write. Designed to
//              purposely utilize BRAM which requires synchronous reads and write
//              ADDR1 used for Program Memory Instruction. Word addressable so it
//              must be adapted from byte addresses in connection from PC
//              ADDR2 used for data access, both internal and external memory
//              mapped IO. ADDR2 is byte addressable.
//              RDEN1 and EDEN2 are read enables for ADDR1 and ADDR2. These are 
//              needed due to synchronous reading
//              MEM_SIZE used to specify reads as byte (0), half (1), or word (2)
//              MEM_SIGN used to specify unsigned (1) vs signed (0) extension
//              IO_IN is data from external IO and synchronously buffered
//
// Memory OTTER_MEMORY (
//    .MEM_CLK   (),
//    .MEM_RDEN1 (), 
//    .MEM_RDEN2 (), 
//    .MEM_WE2   (),
//    .MEM_ADDR1 (),
//    .MEM_ADDR2 (),
//    .MEM_DIN2  (),  
//    .MEM_SIZE  (),
//    .MEM_SIGN  (),
//    .IO_IN     (),
//    .IO_WR     (),
//    .MEM_DOUT1 (),
//    .MEM_DOUT2 ()  ); 
//
// Revision:
// Revision 0.01 - Original by J. Callenes
// Revision 1.02 - Rewrite to simplify logic by P. Hummel
// Revision 1.03 - changed signal names, added instantiation template
// Revision 1.04 - added defualt to write case statement
// Revision 1.05 - changed MEM_WD to MEM_DIN2, changed default to save nothing
// Revision 1.06 - removed type in instantiation template
//
//////////////////////////////////////////////////////////////////////////////////
                                                                                                                             
  module VIDEO_MEMORY (
    input MEM_CLK,
    input MEM_RDEN1,        // read enable data1
    input MEM_RDEN2,        // read enable data2
    input MEM_WE2,          // write enable.
    input [14:0] MEM_ADDR1, // data1 memory address
    input [14:0] MEM_ADDR2, // data2 memory address
    input [7:0] MEM_DIN2,   // Data to save (1px)

    output logic [7:0] MEM_DOUT1, // data1 memory output
    output logic [7:0] MEM_DOUT2  // data2 memory output
    ); 
           
    (* rom_style="{distributed | block}" *)
    (* ram_decomp = "power" *) logic [7:0] memory [0:32767]; // 8k x 32 bit memory or 32k x 8 bit memory
    
    
    // BRAM requires all reads and writes to occur synchronously
    always_ff @(posedge MEM_CLK) begin
        // save data (WD) to memory (ADDR2)
        if (MEM_WE2 == 1) begin  // write enable
            memory[MEM_ADDR2] <= MEM_DIN2;      // store data at addr
        end
        
        // read all data synchronously required for BRAM
        if(MEM_RDEN1)                       // need EN for extra load cycle to not change instruction
            MEM_DOUT1 <= memory[MEM_ADDR1]; // 0 - 30k

        if(MEM_RDEN2)                         // Read word from memory
            MEM_DOUT2 <= memory[MEM_ADDR2];
    end
        
 endmodule
