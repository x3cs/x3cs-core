//------------------------------------------------------------------------------
//
// tb_curve_multiplier_384.v
// -----------------------------------------------------------------------------
// Testbench for 384-bit curve base point scalar multiplier.
//
// Authors: Pavel Shatov
//
// Copyright (c) 2016, 2018 NORDUnet A/S
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// - Neither the name of the NORDUnet nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//------------------------------------------------------------------------------

module tb_curve_multiplier_384;


        //
        // Test Vectors
        //
    `include "ecdsa384_test_vector_nsa.vh"
    `include "ecdsa_test_vector_randomized.vh"


        //
        // Core Parameters
        //
    localparam WORD_COUNTER_WIDTH =  4;
    localparam OPERAND_NUM_WORDS  = 12;


       //
       // P-384 Domain Parameters
       //
    localparam ECDSA_P384_N =
        {32'hffffffff, 32'hffffffff, 32'hffffffff, 32'hffffffff,
         32'hffffffff, 32'hffffffff, 32'hc7634d81, 32'hf4372ddf,
         32'h581a0db2, 32'h48b0a77a, 32'hecec196a, 32'hccc52973};

    localparam ECDSA_P384_GX =
        {32'haa87ca22, 32'hbe8b0537, 32'h8eb1c71e, 32'hf320ad74,
         32'h6e1d3b62, 32'h8ba79b98, 32'h59f741e0, 32'h82542a38,
         32'h5502f25d, 32'hbf55296c, 32'h3a545e38, 32'h72760ab7};

    localparam ECDSA_P384_GY =
        {32'h3617de4a, 32'h96262c6f, 32'h5d9e98bf, 32'h9292dc29,
         32'hf8f41dbd, 32'h289a147c, 32'he9da3113, 32'hb5f0b8c0,
         32'h0a60b1ce, 32'h1d7e819d, 32'h7a431d7c, 32'h90ea0e5f};

    localparam ECDSA_P384_HX =
        {32'h08d99905, 32'h7ba3d2d9, 32'h69260045, 32'hc55b97f0,
         32'h89025959, 32'ha6f434d6, 32'h51d207d1, 32'h9fb96e9e,
        32'h4fe0e86e, 32'hbe0e64f8, 32'h5b96a9c7, 32'h5295df61};

    localparam ECDSA_P384_HY =
        {32'h8e80f1fa, 32'h5b1b3ced, 32'hb7bfe8df, 32'hfd6dba74,
         32'hb275d875, 32'hbc6cc43e, 32'h904e505f, 32'h256ab425,
         32'h5ffd43e9, 32'h4d39e22d, 32'h61501e70, 32'h0a940e80};


        //
        // Clock (100 MHz)
        //
    reg clk = 1'b0;
    always #5 clk = ~clk;


        //
        // Inputs, Outputs
        //
    reg  rst_n;
    reg  ena;
    wire rdy;


        //
        // Buffers (K, PX, PY)
        //
    wire [WORD_COUNTER_WIDTH-1:0] core_k_addr;
    wire [WORD_COUNTER_WIDTH-1:0] core_pxy_addr;

    wire                          core_px_wren;
    wire                          core_py_wren;

    wire [                32-1:0] core_k_data;
    wire [                32-1:0] core_pxy_data;

    reg  [WORD_COUNTER_WIDTH-1:0] tb_k_addr;
    reg  [WORD_COUNTER_WIDTH-1:0] tb_pxy_addr;

    reg                           tb_k_wren;

    reg  [                  31:0] tb_k_data;
    wire [                  31:0] tb_px_data;
    wire [                  31:0] tb_py_data;

    bram_1rw_1ro_readfirst # (.MEM_WIDTH(32), .MEM_ADDR_BITS(WORD_COUNTER_WIDTH))
    bram_k
    (   .clk(clk),
        .a_addr(tb_k_addr), .a_wr(tb_k_wren), .a_in(tb_k_data), .a_out(),
        .b_addr(core_k_addr), .b_out(core_k_data)
    );

    bram_1rw_1ro_readfirst # (.MEM_WIDTH(32), .MEM_ADDR_BITS(WORD_COUNTER_WIDTH))
    bram_px
    (   .clk(clk),
        .a_addr(core_pxy_addr), .a_wr(core_px_wren), .a_in(core_pxy_data), .a_out(),
        .b_addr(tb_pxy_addr), .b_out(tb_px_data)
    );

    bram_1rw_1ro_readfirst # (.MEM_WIDTH(32), .MEM_ADDR_BITS(WORD_COUNTER_WIDTH))
    bram_py
    (   .clk(clk),
        .a_addr(core_pxy_addr), .a_wr(core_py_wren), .a_in(core_pxy_data), .a_out(),
        .b_addr(tb_pxy_addr), .b_out(tb_py_data)
    );


        //
        // UUT
        //
    ecdsa384_base_point_multiplier uut
    (
        .clk        (clk),
        .rst_n      (rst_n),

        .ena        (ena),
        .rdy        (rdy),

        .k_addr     (core_k_addr),
        .rxy_addr   (core_pxy_addr),

        .rx_wren    (core_px_wren),
        .ry_wren    (core_py_wren),

        .k_din      (core_k_data),

        .rxy_dout   (core_pxy_data)
    );


        //
        // Testbench Routine
        //
    reg ok = 1;
    initial begin

            /* initialize control inputs */
        rst_n = 0;
        ena   = 0;
        
            /* wait for some time */
        #200;
        
            /* de-assert reset */
        rst_n = 1;
        
            /* wait for some time */
        #100;
        
            /* run tests */
        $display("1. Q1 = d1 * G...");
        test_curve_multiplier(ECDSA_P384_D_NSA, ECDSA_P384_QX_NSA, ECDSA_P384_QY_NSA);
        
        $display("2. R = k * G...");
        test_curve_multiplier(ECDSA_P384_K_NSA, ECDSA_P384_RX_NSA, ECDSA_P384_RY_NSA);
        
        $display("3. Q2 = d2 * G...");
        test_curve_multiplier(ECDSA_P384_D_RANDOM, ECDSA_P384_QX_RANDOM, ECDSA_P384_QY_RANDOM);

        $display("4. O = n * G...");
        test_curve_multiplier(ECDSA_P384_N, 384'd0, 384'd0);

        $display("5. G = (n + 1) * G...");
        test_curve_multiplier(ECDSA_P384_N + 384'd1, ECDSA_P384_GX, ECDSA_P384_GY);

        $display("6. H = 2 * G...");
        test_curve_multiplier(384'd2, ECDSA_P384_HX, ECDSA_P384_HY);

        $display("7. H = (n + 2) * G...");
        test_curve_multiplier(ECDSA_P384_N + 384'd2, ECDSA_P384_HX, ECDSA_P384_HY);

            /* print result */
        if (ok) $display("tb_curve_multiplier_384: SUCCESS");
        else    $display("tb_curve_multiplier_384: FAILURE");

        //$finish;

    end


        //
        // Test Task
        //
    reg p_ok;

    integer w;

    task test_curve_multiplier;
    
        input [383:0] k;
        input [383:0] px;
        input [383:0] py;

        reg [383:0] k_shreg;
        reg [383:0] px_shreg;
        reg [383:0] py_shreg;

        begin
        
                /* start filling memories */
            tb_k_wren = 1;

                /* initialize shift registers */
            k_shreg = k;

                /* write all the words */
            for (w=0; w<OPERAND_NUM_WORDS; w=w+1) begin

                    /* set addresses */
                tb_k_addr = w[WORD_COUNTER_WIDTH-1:0];

                    /* set data words */
                tb_k_data   = k_shreg[31:0];

                    /* shift inputs */
                k_shreg = {{32{1'bX}}, k_shreg[383:32]};

                    /* wait for 1 clock tick */
                #10;

            end

                /* wipe addresses */
            tb_k_addr = {WORD_COUNTER_WIDTH{1'bX}};

                /* wipe data words */
            tb_k_data = {32{1'bX}};

                /* stop filling memories */
            tb_k_wren = 0;

                /* start operation */
            ena = 1;

                /* clear flag */
            #10 ena = 0;

                /* wait for operation to complete */
            while (!rdy) #10;

                /* read result */
            for (w=0; w<OPERAND_NUM_WORDS; w=w+1) begin

                    /* set address */
                tb_pxy_addr = w[WORD_COUNTER_WIDTH-1:0];

                    /* wait for 1 clock tick */
                #10;

                    /* store data word */
                px_shreg = {tb_px_data, px_shreg[383:32]};
                py_shreg = {tb_py_data, py_shreg[383:32]};

            end

                /* compare */
            p_ok = (px_shreg === px) &&
                   (py_shreg === py);

                /* display results */
            if (p_ok) $display("test_curve_multiplier(): OK");
            else begin
                $display("test_curve_multiplier(): ERROR");
                $display("ref_px  == %x", px);
                $display("calc_px == %x", px_shreg);
                $display("ref_py  == %x", py);
                $display("calc_py == %x", py_shreg);
            end

                /* update global flag */
            ok = ok && p_ok;
        
        end

    endtask

endmodule


//------------------------------------------------------------------------------
// End-of-File
//------------------------------------------------------------------------------
