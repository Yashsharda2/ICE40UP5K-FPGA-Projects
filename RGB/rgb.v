module rgb(
input clk,
input rst,
input start,
input [23:0] colour,
output reg din_out
);

reg [2:0]  state;
reg [4:0]  bit_idx;  
reg [9:0]  cycle_cnt;  
reg        current_bit;  
reg[3:0] led_count;

localparam IDLE = 3'd0;
localparam LOAD = 3'd1;
localparam START_H = 3'd2;
localparam START_L = 3'd3;
localparam NEXT = 3'd4;
localparam RESET = 3'd5;

localparam T1H = 10;  // ~800ns
localparam T0H = 5;   // ~400ns
localparam T1L = 5;   // ~450ns
localparam T0L = 10;  // ~850ns
localparam TRST = 1000; // >50us

always@(posedge clk)begin
if(rst)begin
din_out<=0;
cycle_cnt<=0;
state<=IDLE;
bit_idx<=5'd0;
current_bit<=0;
led_count<=0;
end
else begin

case(state)
IDLE:begin
din_out<=0;
current_bit<=0;
bit_idx<=5'd23;
led_count<=0;

if(start) begin
state<=LOAD;
end else begin
state<=IDLE;
end
end

LOAD:begin
current_bit<=colour[bit_idx];
state<=START_H;
end

START_H:begin
din_out<=1'b1;

if(current_bit==1'b1)begin
if(cycle_cnt>T1H-1)begin
cycle_cnt<=0;
state<=START_L;
end else begin
cycle_cnt<=cycle_cnt+1;
end
end else begin
if (cycle_cnt >= T0H - 1) begin
   cycle_cnt <= 0;
   state<= START_L;
end else begin
    cycle_cnt <= cycle_cnt + 1;
end
end
end

START_L: begin
din_out <= 1'b0;             
if (current_bit == 1'b1) begin
if (cycle_cnt >= T1L - 1) begin
   cycle_cnt <= 0;
   state<= NEXT;
end else begin
   cycle_cnt <= cycle_cnt + 1;
end
end else begin 
if (cycle_cnt >= T0L - 1) begin
    cycle_cnt <= 0;
    state <= NEXT;
end else begin
    cycle_cnt <= cycle_cnt + 1;
end
end
end

NEXT: begin
if (bit_idx == 0) begin
if (led_count == 4'd15) begin
   state <= RESET; 
end else begin
   led_count <= led_count + 1;
   bit_idx   <= 5'd23;  
   state     <= LOAD;
end
end else begin
   bit_idx <= bit_idx - 1;
   state   <= LOAD;
end
end

RESET:begin
din_out <= 1'b0; 
            
if (cycle_cnt >= TRST - 1) begin
    cycle_cnt <= 0;
    state <= IDLE; 
end else begin
   cycle_cnt <= cycle_cnt + 1;
end
end
endcase
end
end
endmodule
