class arbiter_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(arbiter_scoreboard)

    uvm_analysis_imp #(arbiter_item, arbiter_scoreboard) analysis_export;

    logic [1:0] ref_last_grant;
    logic [3:0] expected_grant;
    logic       found;
    integer     idx;

    function new(string name = "arbiter_scoreboard",
                 uvm_component parent = null);
        super.new(name, parent);

        analysis_export = new("analysis_export", this);
        ref_last_grant = 2'd3;
    endfunction

    function void write(arbiter_item item);

        expected_grant = 4'b0000;
        found = 1'b0;
        idx = 0;

        if (!item.rst_n) begin
            expected_grant = 4'b0000;
            ref_last_grant = 2'd3;
        end
        else if (item.policy == 1'b0) begin

            if (item.req[0])
                expected_grant = 4'b0001;
            else if (item.req[1])
                expected_grant = 4'b0010;
            else if (item.req[2])
                expected_grant = 4'b0100;
            else if (item.req[3])
                expected_grant = 4'b1000;

        end
        else begin

            for (int offset = 1; offset <= 4; offset++) begin
                idx = (ref_last_grant + offset) % 4;

                if (!found && item.req[idx]) begin
                    expected_grant[idx] = 1'b1;
                    found = 1'b1;
                end
            end

        end

        if (item.grant !== expected_grant) begin
            `uvm_error("SCB",
                $sformatf("req=%b policy=%b expected=%b actual=%b",
                          item.req,
                          item.policy,
                          expected_grant,
                          item.grant))
        end

        if (item.rst_n && item.policy == 1'b1) begin
            case (expected_grant)
                4'b0001: ref_last_grant = 2'd0;
                4'b0010: ref_last_grant = 2'd1;
                4'b0100: ref_last_grant = 2'd2;
                4'b1000: ref_last_grant = 2'd3;
            endcase
        end

    endfunction

endclass