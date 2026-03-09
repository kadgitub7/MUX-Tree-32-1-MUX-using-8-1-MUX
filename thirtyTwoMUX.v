`timescale 1ns / 1ps

module thirtyTwoMUX(
    input I0,
    input I1,
    input I2,
    input I3,
    input I4,
    input I5,
    input I6,
    input I7,
    input I8,
    input I9,
    input I10,
    input I11,
    input I12,
    input I13,
    input I14,
    input I15,
    input I16,
    input I17,
    input I18,
    input I19,
    input I20,
    input I21,
    input I22,
    input I23,
    input I24,
    input I25,
    input I26,
    input I27,
    input I28,
    input I29,
    input I30,
    input I31,
    input S0,
    input S1,
    input S2,
    input S3,
    input S4,
    input S5,
    output Y
    );
    
    wire E1,E2,E3,E4;
    assign E1 = ~S4 &~S3;
    assign E2 = ~S4 &S3;
    assign E3 = S4 &~S3;
    assign E4 = S4 &S3;
    
    wire out1,out2,out3,out4;
    
    eightOneMultiplexer mux1(I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2,E1,out1);
    eightOneMultiplexer mux2(I8,I9,I10,I11,I12,I13,I14,I15,S0,S1,S2,E2,out2);
    eightOneMultiplexer mux3(I16,I17,I18,I19,I20,I21,I22,I23,S0,S1,S2,E3,out3);
    eightOneMultiplexer mux4(I24,I25,I26,I27,I28,I29,I30,I31,S0,S1,S2,E4,out4);
    
    assign Y = out1| out2|out3|out4;
        
endmodule
