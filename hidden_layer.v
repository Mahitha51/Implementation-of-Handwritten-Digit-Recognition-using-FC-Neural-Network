module hidden_layer
 (
    input [27:0] inp_image,    // 28x28 input image size (each cycle gets a new row)
    input clk,
    input reset,
    output reg mul_done,       // Output flag to indicate multiplication is done
    output reg [15:0] neu_out [0:9]  // Output for the 10 neurons
);

    reg [15:0] weights [0:7839]; // 784 weights per neuron, total 10 neurons = 784 * 10 = 7840 weights
    reg [15:0] bias [0:9];       // Bias for each of the 10 neurons
    reg [15:0] acc [0:9];        // Accumulator for MAC operation for each neuron
    reg [4:0] row_count;         // Row counter for 28 rows
    reg [6:0] col_count;         // Column counter for 28 columns (0 to 27)

    integer i, j;

    // Load weights and bias from memory files
    initial begin
        $readmemb("weights.mem", weights); // Read weights from file
        $readmemb("bias.mem", bias);       // Read biases from file
    end

    // Reset and initialize
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            row_count <= 0;
            col_count <= 0;
            mul_done <= 0;
            for (i = 0; i < 10; i = i + 1) begin
                acc[i] <= 0;
            end
        end else begin
            if (row_count < 28) begin
                // Perform MAC operation for each neuron
                for (j = 0; j < 10; j = j + 1) begin
                    acc[j] <= acc[j] + inp_image[col_count] * weights[row_count * 784 + col_count + j * 784];
                end

                // Move to the next column
                col_count <= col_count + 1;

                // Check if a row is completed
                if (col_count == 27) begin
                    col_count <= 0;
                    row_count <= row_count + 1;
                end

                // Check if all rows are completed
                if (row_count == 27 && col_count == 27) begin
                    mul_done <= 1;
                    // Add bias to the accumulated values and store in neu_out
                    for (j = 0; j < 10; j = j + 1) begin
                        neu_out[j] <= acc[j] + bias[j];
                    end
                end
            end
        end
    end
endmodule
