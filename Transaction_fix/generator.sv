class generator;
  transaction trans;
  mailbox#(transaction) gen2drv;
  
  function new(mailbox#(transaction) gen2drv);
    this.gen2drv=gen2drv;
    trans=new();
  endfunction
  
  task run();
    repeat(1)begin
      trans.randomize();
      gen2drv.put(trans.copy);
      trans.display("[GEN]DATA SEND TO DRIVER");
    end
  endtask
endclass