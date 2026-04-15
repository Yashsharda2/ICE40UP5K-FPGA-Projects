module uart_tx(
input clk,
input rst,
input data_valid,
output reg tx,
input [7:0] data_in
);

reg[7:0] shift_reg;
reg[10:0] counter;
reg[1:0] state;
reg[2:0] bit_idx;

localparam IDLE  = 2'd0;
localparam START  = 2'd1;
localparam DATA = 2'd2;
localparam DONE  = 2'd3;

reg sw_prev;
always@(posedge clk) sw_prev<=data_valid;

wire start = (sw_prev == 1'b1 && data_valid == 1'b0);


always@(posedge clk)begin
if(rst)begin
counter<=0;
state<=IDLE;
tx<=1'b1;
bit_idx<=0;;
end
else begin

case(state)
IDLE : begin
tx<=1'b1;
counter<=0;
if(start) begin
shift_reg<=data_in;
state<=START;
end
end
default: begin
if(counter<11'd1249)begin
counter<=counter+1;
end else begin
counter<=0;

case(state)
START: begin
tx<=1'b0;
state<=DATA;
bit_idx<=0;
end

DATA:begin
tx<=shift_reg[bit_idx];
if(bit_idx == 3'd7)begin
state<=DONE;
end else begin
bit_idx<=bit_idx+1;
end
end

DONE : begin
tx<=1'b1;
state<=IDLE;
end
endcase
end
end
endcase
end
end
endmodule
