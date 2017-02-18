
//
// RISCV multi-cycle implementation.
//
// Module:      rvm_adder
//
// Description: A 32 bit add/subtract unit with two inputs and overflow
//              detection.
//
// op   | operation
// -----|-----------------------
//  00  | NOP                   
//  01  | ADD                   
//  10  | SUB                   
//  11  | Undefined             
//

`include "rvm_constants.v"

module rvm_adder(

input  wire [31:0] lhs,      // Value on left-hand side of + operator
input  wire [31:0] rhs,      // Value on right-hand side of + operator

input  wire [2:0]  op,       // What to do?

output wire        valid,    // Asserts that the result is complete.
output wire [32:0] result,   // The result of the addition / subtraction
output wire        eq,
output wire        gt
);

//
// Isolate inputs to the adder when the module is not enabled.
wire [32:0] i_lhs = lhs & {32{op != `RVM_BITWISE_NOP}};
wire [31:0] i_rhs = rhs & {32{op != `RVM_BITWISE_NOP}};

assign valid = op != `RVM_ARITH_NOP;

//
// Compute the result
assign result = ({33{op == `RVM_ARITH_ADD}} & (i_lhs + i_rhs)) |
                ({33{op == `RVM_ARITH_SUB}} & (i_lhs - i_rhs)) ;


endmodule
