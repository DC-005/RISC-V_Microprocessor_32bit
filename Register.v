module register_File(CLK,rst,WE3,WD3,A1,A2,A3,RD1,RD2);
    input CLK,rst,WE3;
    input [4:0] A1,A2,A3;
    input [31:0]WD3;
    output reg [31:0]RD1,RD2;
    integer i;

    reg [31:0] register [31:0];
    always @ (posedge rst or negedge CLK) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) 
                register[i] <= 32'b0; // Reset all registers to 0
        end 
        else if (WE3 && A3 != 5'b0) 
            register[A3] <= WD3; // Write data when enabled
    end

    // **Combinational Read Logic**
    always @(*) begin
        RD1 = (A1 == 5'h0) ? 32'b0 : register[A1]; // Register 0 always reads as 0
        RD2 = (A2 == 5'h0) ? 32'b0 : register[A2];
    end

endmodule










