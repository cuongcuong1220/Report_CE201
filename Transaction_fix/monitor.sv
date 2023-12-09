class monitor;
    virtual alu_if alu_vif;
    mailbox #(transaction) mon2scb;
    function new (virtual alu_if alu_vif, mailbox #(transaction)mon2scb);
        this.alu_vif=alu_vif;
        this.mon2scb=mon2scb;
    endfunction

  task run();
   
    repeat(1)
      #30
        begin
          	transaction trans;
    		trans=new();
            trans.in0=alu_vif.in0;
            trans.in1=alu_vif.in1;
            trans.en=alu_vif.en;
            trans.sel=alu_vif.sel;
            trans.out=alu_vif.out;
            mon2scb.put(trans);
          trans.display("[MON]DATA SEND TO SCOREBOARD");
        end
    endtask
endclass