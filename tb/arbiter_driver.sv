class arbiter_driver extends uvm_driver #(arbiter_item);

    `uvm_component_utils(arbiter_driver)

    virtual arbiter_if vif;

    function new(string name = "arbiter_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual arbiter_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Failed to get virtual interface")
    endfunction

    task run_phase(uvm_phase phase);

        forever begin
            seq_item_port.get_next_item(req);

            @(posedge vif.clk);

            vif.req    <= req.req;
            vif.policy <= req.policy;

            seq_item_port.item_done();
        end

    endtask

endclass