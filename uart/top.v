module top(
    input clk,         
    input [3:0] SW,    
    output P1_1 
);

wire [7:0] test_data = 8'b10101010;

    uart_tx uu (
        .clk(clk),
        .rst(1'b0),            
        .data_valid(SW[0]),    
        .data_in(test_data),   
        .tx(P1_1)                
    );

endmodule
