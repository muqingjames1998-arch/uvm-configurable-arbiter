module tb_top;

    import uvm_pkg::*;
    import arbiter_pkg::*;

    logic clk;

    arbiter_if arb_if(clk);

    configurable_arbiter dut (
        .clk    (clk),
        .rst_n  (arb_if.rst_n),
        .req    (arb_if.req),
        .policy (arb_if.policy),
        .grant  (arb_if.grant)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        arb_if.rst_n  = 1'b0;
        arb_if.req    = 4'b0000;
        arb_if.policy = 1'b0;

        repeat (2) @(posedge clk);
        arb_if.rst_n = 1'b1;
    end

    initial begin
        uvm_config_db #(virtual arbiter_if)::set(
            null,
            "*",
            "vif",
            arb_if
        );

        run_test("arbiter_test");
    end

endmodule