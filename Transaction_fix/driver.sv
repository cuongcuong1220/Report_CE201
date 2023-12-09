class driver;
  virtual alu_if alu_vif;
  transaction trans;
  mailbox#(transaction) gen2drv;
  
  function new(virtual alu_if alu_vif,mailbox#(transaction) gen2drv);
    this.alu_vif=alu_vif;
    this.gen2drv=gen2drv;
  endfunction
  
  task run();
    repeat(1)begin
      gen2drv.get(trans);
      alu_vif.in0<=trans.in0;
      alu_vif.in1<=trans.in1;
      alu_vif.en<=trans.en;
      alu_vif.sel<=trans.sel;
      trans.display("[DRV]DRIVER RECIVED DATA FROM GENERATOR");
      trans.out=alu_vif.out;
    end
  endtask
endclass