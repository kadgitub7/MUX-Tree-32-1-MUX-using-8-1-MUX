`timescale 1ns / 1ps

module thirtyTwoMUX_tb();
    reg I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,I21,I22,I23,I24,I25,I26,I27,I28,I29,I30,I31;
    reg S0,S1,S2,S3,S4;
    wire Y;
    
    thirtyTwoMUX uut(I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16,I17,I18,I19,I20,I21,I22,I23,I24,I25,I26,I27,I28,I29,I30,I31, S0,S1,S2,S3,S4,Y);
    integer i;
    
    initial begin
        I0=0;  I1=1;  I2=0;  I3=1;
        I4=0;  I5=1;  I6=0;  I7=1;

        I8=1;  I9=0;  I10=1; I11=0;
        I12=1; I13=0; I14=1; I15=0;

        I16=0; I17=0; I18=1; I19=1;
        I20=0; I21=0; I22=1; I23=1;

        I24=1; I25=1; I26=0; I27=0;
        I28=1; I29=1; I30=0; I31=0;

        for(i = 0; i < 32; i = i + 1) begin
        
            {S4,S3,S2,S1,S0} = i;
        
            #10;
            $display("SEL=%b%b%b%b%b  Y=%b",S4,S3,S2,S1,S0,Y);
        end
    end
endmodule
