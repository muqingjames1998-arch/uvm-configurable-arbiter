class arbiter_monitor extends uvm_monitor;

    `uvm_component_utils(arbiter_monitor)

    virtual arbiter_if vif;

    uvm_analysis_port #(arbiter_item) ap;

    function new(string name = "arbiter_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual arbiter_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Failed to get virtual interface")
    endfunction

    task run_phase(uvm_phase phase);

        arbiter_item item;

        forever begin
            @(negedge vif.clk);

            item = arbiter_item::type_id::create("item");

            item.rst_n  = vif.rst_n;
            item.req    = vif.req;
            item.policy = vif.policy;
            item.grant  = vif.grant;

            ap.write(item);
        end

    endtask

endclass