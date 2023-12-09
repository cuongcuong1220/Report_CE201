//environmet class
class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;
    mailbox #(transaction)m1;
    mailbox #(transaction)m2;
    virtual alu_if alu_vif;
    function new(virtual alu_if alu_vif);
        this.alu_vif=alu_vif;
        m1=new();
        m2=new();
        gen=new(m1);
        drv=new(alu_vif,m1);
        mon=new(alu_vif,m2);
        scb=new(m2);
    endfunction

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join
    endtask

    task run;
        test();
        $finish;
    endtask
endclass