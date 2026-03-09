`timescale 1ns / 1ps

module eightOneMultiplexer(
    input I0,
    input I1,
    input I2,
    input I3,
    input I4,
    input I5,
    input I6,
    input I7,
    input S0,
    input S1,
    input S2,
    input E,
    output Y
    );
    
    assign Y = E&(~S2&~S1&~S0&I0 | ~S2&~S1&S0&I1 | ~S2&S1&S0&I3 | S2&~S1&~S0&I4 | S2&~S1&S0&I5 | S2&S1&~S0&I6 | S2&S1&S0&I7);
endmodule