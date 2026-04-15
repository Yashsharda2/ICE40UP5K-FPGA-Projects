module top(
    input clk,          // From io.pcf: Pin 35
    input [3:0] SW,     // From io.pcf: SW[0] is Pin 18
    output P1_1         // From io.pcf: Pin 10 (UART TX Output)
);

    // Hardcoded data: 8'b10010010 (0x92)
    // UART sends LSB first, so the line will see: 
    // START(0) -> 0 -> 1 -> 0 -> 0 -> 1 -> 0 -> 0 -> 1 -> STOP(1)
    wire [7:0] test_data = 8'b10101010;

    // Instantiate your UART module
    uart_tx transmitter (
        .clk(clk),
        .rst(1'b0),              // No hardware reset button, so tie to 0
        .data_valid(SW[0]),      // Trigger on DIP switch flip
        .data_in(test_data),     // Hardcoded data input
        .tx(P1_1)                // Output to PMOD header pin
    );

endmodule
