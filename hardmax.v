module hardmax (
    input [15:0] final_out [0:9],  // Final output values from the output layer
    input clk,
    input reset,
    output reg [3:0] max_index,    // Index of the maximum value (0-9)
    output reg max_done            // Output flag to indicate operation is done
);

    integer i;
    reg [15:0] max_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            max_index <= 0;
            max_value <= 0;
            max_done <= 0;
        end else begin
            max_value <= final_out[0];
            max_index <= 0;

            // Loop through final_out to find the maximum value
            for (i = 1; i < 10; i = i + 1) begin
                if (final_out[i] > max_value) begin
                    max_value <= final_out[i];
                    max_index <= i;
                end
            end

            max_done <= 1;
        end
    end
endmodule