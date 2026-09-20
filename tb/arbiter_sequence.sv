class arbiter_sequence extends uvm_sequence #(arbiter_item);

    `uvm_object_utils(arbiter_sequence)

    function new(string name = "arbiter_sequence");
        super.new(name);
    endfunction

    task body();

        arbiter_item item;

        repeat (20) begin
            item = arbiter_item::type_id::create("item");

            start_item(item);

            if (!item.randomize())
                `uvm_error("SEQ", "Randomization failed")

            finish_item(item);
        end

    endtask

endclass