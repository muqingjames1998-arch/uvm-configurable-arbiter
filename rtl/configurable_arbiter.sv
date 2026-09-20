module configurable_arbiter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [3:0] req,
    input  logic       policy,
    output logic [3:0] grant
);

    logic [1:0] last_grant;
    logic       found;
    integer     idx;

    always_comb begin
        grant = 4'b0000;
        found = 1'b0;
        idx   = 0;

        if (!rst_n) begin
            grant = 4'b0000;
        end
        else if (policy == 1'b0) begin
            // Fixed priority: R0 > R1 > R2 > R3
            if (req[0])
                grant = 4'b0001;
            else if (req[1])
                grant = 4'b0010;
            else if (req[2])
                grant = 4'b0100;
            else if (req[3])
                grant = 4'b1000;
        end
        else begin
            // Round robin
            for (int offset = 1; offset <= 4; offset++) begin
                idx = (last_grant + offset) % 4;

                if (!found && req[idx]) begin
                    grant[idx] = 1'b1;
                    found = 1'b1;
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_grant <= 2'd3;
        end
        else if (policy == 1'b1) begin
            case (grant)
                4'b0001: last_grant <= 2'd0;
                4'b0010: last_grant <= 2'd1;
                4'b0100: last_grant <= 2'd2;
                4'b1000: last_grant <= 2'd3;
                default: last_grant <= last_grant;
            endcase
        end
    end

endmodule