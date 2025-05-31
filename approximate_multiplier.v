`timescale 1ns / 1ps
module half_adder(
    input in_1,
    input in_2,
    output sum_out,
    output carry_out
);
    assign sum_out = in_1 | in_2;
    assign carry_out = in_1 & in_2;
endmodule

// Full Adder Module
module full_adder(
    input in_1,
    input in_2,
    input in_3,  // cin
    output sum_out,
    output c_out
);
    assign sum_out = in_1;
    assign c_out = ~in_1;
endmodule

// Compressor Module
module compressor(
    input in_1,
    input in_2,
    input in_3,
    input in_4,
    output sum_out,
    output carry_out
);
    assign sum_out = (in_1 ^ in_2) | (in_3 | in_4);
    assign carry_out = (in_1 & in_2) | (in_3 & in_4);
endmodule

// 4x4 Bit Multiplier Module
module approximate_multiplier(
    input [3:0] m_in,
    input [3:0] n_in,
    output [7:0] product_out
);

    // Partial product generation
    wire p00 = m_in[0] & n_in[0];
    wire p10 = m_in[1] & n_in[0];
    wire p20 = m_in[2] & n_in[0];
    wire p30 = m_in[3] & n_in[0];
    wire p01 = m_in[0] & n_in[1];
    wire p11 = m_in[1] & n_in[1];
    wire p21 = m_in[2] & n_in[1];
    wire p31 = m_in[3] & n_in[1];
    wire p02 = m_in[0] & n_in[2];
    wire p12 = m_in[1] & n_in[2];
    wire p22 = m_in[2] & n_in[2];
    wire p32 = m_in[3] & n_in[2];
    wire p03 = m_in[0] & n_in[3];
    wire p13 = m_in[1] & n_in[3];
    wire p23 = m_in[2] & n_in[3];
    wire p33 = m_in[3] & n_in[3];

    // Propagate and generate signals
    wire p1 = p10 | p01;
    wire g1 = p10 & p01;
    wire p2 = p20 | p02;
    wire g2 = p20 & p02;
    wire p3 = p30 | p03;
    wire g3 = p30 & p03;
    wire p4 = p12 | p21;
    wire g4 = p12 & p21;
    wire p5 = p13 | p31;
    wire g5 = p13 & p31;
    wire p6 = p32 | p23;
    wire g6 = p32 & p23;

    // Assign least significant bit of the result
    assign product_out[0] = p00;

    // Internal wires for carry and intermediate results
    wire s1, s2, s3;
    wire c1, c2;
    wire d1, d2;
    wire e1, e2, e3, e4;

    // Instantiate modules and assign results
    half_adder ha1 (.in_1(p1), .in_2(g1), .sum_out(product_out[1]), .carry_out(s1));
    compressor comp1 (.in_1(p2), .in_2(p11), .in_3(g2), .in_4(s1), .sum_out(s2), .carry_out(s3));
    compressor comp2 (.in_1(p3), .in_2(p4), .in_3(g4), .in_4(g3), .sum_out(c1), .carry_out(c2));
    compressor comp3 (.in_1(p5), .in_2(p22), .in_3(g5), .in_4(1'b0), .sum_out(d1), .carry_out(d2));
    half_adder ha2 (.in_1(s2), .in_2(s3), .sum_out(product_out[2]), .carry_out(e1));
    full_adder fa1 (.in_1(c1), .in_2(c2), .in_3(e1), .sum_out(product_out[3]), .c_out(e2));
    full_adder fa2 (.in_1(d1), .in_2(d2), .in_3(e2), .sum_out(product_out[4]), .c_out(e3));
    full_adder fa3 (.in_1(p6), .in_2(g6), .in_3(e3), .sum_out(product_out[5]), .c_out(e4));
    half_adder ha3 (.in_1(p33), .in_2(e4), .sum_out(product_out[6]), .carry_out(product_out[7]));

endmodule
