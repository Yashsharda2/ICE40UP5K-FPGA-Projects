module top(
input clk,
input [3:0] SW,
output led_din
);

wire rst = 1'b0;
wire start = 1'b1;

reg [23:0] colour_data;

always@(*)begin
case(SW)
            4'b0000: colour_data = 24'h000000; // 0: All Off
            4'b0001: colour_data = 24'h00FF00; // 1: Pure Red
            4'b0010: colour_data = 24'hFF0000; // 2: Pure Green
            4'b0011: colour_data = 24'h0000FF; // 3: Pure Blue
            
            // --- Secondary Mixes ---
            4'b0100: colour_data = 24'hFFFF00; // 4: Yellow (Red + Green)
            4'b0101: colour_data = 24'h00FFFF; // 5: Magenta (Red + Blue)
            4'b0110: colour_data = 24'hFF00FF; // 6: Cyan (Green + Blue)
            4'b0111: colour_data = 24'hFFFFFF; // 7: White (All On)
            
            // --- "Designer" Colors & Pastels ---
            4'b1000: colour_data = 24'h40FF00; // 8: Orange (Red + bit of Green)
            4'b1001: colour_data = 24'h00FF7F; // 9: Pink (Red + bit of Blue)
            4'b1010: colour_data = 24'hFF8000; // 10: Lime (Green + bit of Red)
            4'b1011: colour_data = 24'h8000FF; // 11: Purple (Blue + bit of Green)
            
            // --- Dim / Power Saving States ---
            4'b1100: colour_data = 24'h001000; // 12: Dim Red
            4'b1101: colour_data = 24'h100000; // 13: Dim Green
            4'b1110: colour_data = 24'h000010; // 14: Dim Blue
            4'b1111: colour_data = 24'h101010; // 15: Dim White
            
            default: colour_data = 24'h000000;
endcase
end

rgb uu(
.clk(clk),
.rst(rst),
.start(start),
.colour(colour_data),
.din_out(led_din)
);

endmodule
