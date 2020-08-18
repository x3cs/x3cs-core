//======================================================================
//
// Copyright (c) 2018, NORDUnet A/S All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// - Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// - Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// - Neither the name of the NORDUnet nor the names of its contributors may
//   be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module ecdsa384_operand_bank
(
    input               clk,

    input   [10-1:0]    a_addr,
    input               a_wr,
    input   [32-1:0]    a_in,

    input   [10-1:0]    b_addr,
    output  [32-1:0]    b_out
);


    //
    // BRAM
    //
    reg [31:0] bram[0:64*16-1];


    //
    // Initialization
    //
    initial begin
        //
        // CONST_ZERO 
        //
        bram[ 0*16 + 11] = 32'h00000000;
        bram[ 0*16 + 10] = 32'h00000000;
        bram[ 0*16 +  9] = 32'h00000000;
        bram[ 0*16 +  8] = 32'h00000000;
        bram[ 0*16 +  7] = 32'h00000000;
        bram[ 0*16 +  6] = 32'h00000000;
        bram[ 0*16 +  5] = 32'h00000000;
        bram[ 0*16 +  4] = 32'h00000000;
        bram[ 0*16 +  3] = 32'h00000000;
        bram[ 0*16 +  2] = 32'h00000000;
        bram[ 0*16 +  1] = 32'h00000000;
        bram[ 0*16 +  0] = 32'h00000000;
        //
        // CONST_ONE
        //
        bram[ 1*16 + 11] = 32'h00000000;
        bram[ 1*16 + 10] = 32'h00000000;
        bram[ 1*16 +  9] = 32'h00000000;
        bram[ 1*16 +  8] = 32'h00000000;
        bram[ 1*16 +  7] = 32'h00000000;
        bram[ 1*16 +  6] = 32'h00000000;
        bram[ 1*16 +  5] = 32'h00000000;
        bram[ 1*16 +  4] = 32'h00000000;
        bram[ 1*16 +  3] = 32'h00000000;
        bram[ 1*16 +  2] = 32'h00000000;
        bram[ 1*16 +  1] = 32'h00000000;
        bram[ 1*16 +  0] = 32'h00000001;
        //
        // CONST_DELTA
        //
        bram[ 2*16 + 11] = 32'h7fffffff;
        bram[ 2*16 + 10] = 32'hffffffff;
        bram[ 2*16 +  9] = 32'hffffffff;
        bram[ 2*16 +  8] = 32'hffffffff;
        bram[ 2*16 +  7] = 32'hffffffff;
        bram[ 2*16 +  6] = 32'hffffffff;
        bram[ 2*16 +  5] = 32'hffffffff;
        bram[ 2*16 +  4] = 32'hffffffff;
        bram[ 2*16 +  3] = 32'h7fffffff;
        bram[ 2*16 +  2] = 32'h80000000;
        bram[ 2*16 +  1] = 32'h00000000;
        bram[ 2*16 +  0] = 32'h80000000;
        //
        // G_X
        //
        bram[ 3*16 + 11] = 32'haa87ca22;
        bram[ 3*16 + 10] = 32'hbe8b0537;
        bram[ 3*16 +  9] = 32'h8eb1c71e;
        bram[ 3*16 +  8] = 32'hf320ad74;
        bram[ 3*16 +  7] = 32'h6e1d3b62;
        bram[ 3*16 +  6] = 32'h8ba79b98;
        bram[ 3*16 +  5] = 32'h59f741e0;
        bram[ 3*16 +  4] = 32'h82542a38;
        bram[ 3*16 +  3] = 32'h5502f25d;
        bram[ 3*16 +  2] = 32'hbf55296c;
        bram[ 3*16 +  1] = 32'h3a545e38;
        bram[ 3*16 +  0] = 32'h72760ab7;
        //
        // G_Y
        //
        bram[ 4*16 + 11] = 32'h3617de4a;
        bram[ 4*16 + 10] = 32'h96262c6f;
        bram[ 4*16 +  9] = 32'h5d9e98bf;
        bram[ 4*16 +  8] = 32'h9292dc29;
        bram[ 4*16 +  7] = 32'hf8f41dbd;
        bram[ 4*16 +  6] = 32'h289a147c;
        bram[ 4*16 +  5] = 32'he9da3113;
        bram[ 4*16 +  4] = 32'hb5f0b8c0;
        bram[ 4*16 +  3] = 32'h0a60b1ce;
        bram[ 4*16 +  2] = 32'h1d7e819d;
        bram[ 4*16 +  1] = 32'h7a431d7c;
        bram[ 4*16 +  0] = 32'h90ea0e5f;
        //
        // H_X
        //
        bram[ 5*16 + 11] = 32'h08d99905;
        bram[ 5*16 + 10] = 32'h7ba3d2d9;
        bram[ 5*16 +  9] = 32'h69260045;
        bram[ 5*16 +  8] = 32'hc55b97f0;
        bram[ 5*16 +  7] = 32'h89025959;
        bram[ 5*16 +  6] = 32'ha6f434d6;
        bram[ 5*16 +  5] = 32'h51d207d1;
        bram[ 5*16 +  4] = 32'h9fb96e9e;
        bram[ 5*16 +  3] = 32'h4fe0e86e;
        bram[ 5*16 +  2] = 32'hbe0e64f8;
        bram[ 5*16 +  1] = 32'h5b96a9c7;
        bram[ 5*16 +  0] = 32'h5295df61;
        //
        // H_Y
        //
        bram[ 6*16 + 11] = 32'h8e80f1fa;
        bram[ 6*16 + 10] = 32'h5b1b3ced;
        bram[ 6*16 +  9] = 32'hb7bfe8df;
        bram[ 6*16 +  8] = 32'hfd6dba74;
        bram[ 6*16 +  7] = 32'hb275d875;
        bram[ 6*16 +  6] = 32'hbc6cc43e;
        bram[ 6*16 +  5] = 32'h904e505f;
        bram[ 6*16 +  4] = 32'h256ab425;
        bram[ 6*16 +  3] = 32'h5ffd43e9;
        bram[ 6*16 +  2] = 32'h4d39e22d;
        bram[ 6*16 +  1] = 32'h61501e70;
        bram[ 6*16 +  0] = 32'h0a940e80;
	end


    //
    // Output Register
    //
    reg [32-1:0] bram_reg_b;

    assign b_out = bram_reg_b;


    //
    // Write Port A
    //
    always @(posedge clk)
        //
        if (a_wr) bram[a_addr] <= a_in;


    //
    // Read Port B
    //
    always @(posedge clk)
        //
        bram_reg_b <= bram[b_addr];


endmodule
