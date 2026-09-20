interface arbiter_if(input logic clk);

    logic       rst_n;
    logic [3:0] req;
    logic       policy;
    logic [3:0] grant;

endinterface