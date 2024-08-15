module output_layer (
    input [15:0] hidden_out [0:9],   // Outputs from the hidden layer (10 nodes)
    input clk,
    input reset,
    output reg output_done,          // Output flag to indicate operation is done
    output reg [15:0] final_out [0:9]  // Final output for the 10 output nodes
);

    reg [15:0] output_weights [0:99]; // 10 weights per output node, total 10 output nodes = 10 * 10 = 100 weights
    reg [15:0] output_bias [0:9];     // Bias for each of the 10 output nodes
    reg [15:0] acc [0:9];             // Accumulator for MAC operation for each output node

    integer i, j;

    // Synchronous Reset and Initialization
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_done <= 0;
            for (i = 0; i < 10; i = i + 1) begin
                acc[i] <= 0;
                final_out[i] <= 0;
            end
        end else begin
            // Perform MAC operation for each output node
            for (j = 0; j < 10; j = j + 1) begin
                for (i = 0; i < 10; i = i + 1) begin
                    acc[j] <= acc[j] + hidden_out[i] * output_weights[i + j * 10];
                end
            end

            // Set the output_done flag and apply bias
            output_done <= 1;
            for (j = 0; j < 10; j = j + 1) begin
                final_out[j] <= acc[j] + output_bias[j];
            end
        end
    end

    // Load output weights and biases from a file in simulation only
    initial begin
        $readmemb("output_weights.mem", output_weights); // Read weights from file
        $readmemb("output_bias.mem", output_bias);       // Read biases from file
    end

endmodule
