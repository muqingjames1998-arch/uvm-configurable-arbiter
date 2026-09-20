class arbiter_item extends uvm_sequence_item;

    rand logic [3:0] req;
    rand logic       policy;

    logic            rst_n;
    logic [3:0]      grant;

    `uvm_object_utils(arbiter_item)

    function new(string name = "arbiter_item");
        super.new(name);
    endfunction

endclass