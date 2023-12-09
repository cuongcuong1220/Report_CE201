/*Transaction class*/
class transaction;
  randc logic [7:0] in0,in1;
  randc logic en;
  randc bit [2:0]sel;
  logic [15:0]out;
  
  function void display(string name);
    $display("-----------------------------------------");
    $display("%s",name);
    $display("enable: %d,select: %b,input0: %d,input1: %d,output:%d",en,sel,in0,in1,out);
    $display("-----------------------------------------");
  endfunction
  
constraint en_constraint {
    en == 1;
  }

function transaction copy();
  copy=new();
  copy.in0= this.in0;
  copy.in1=this.in1;
  copy.en=this.en;
  copy.sel=this.sel;
  copy.out=this.out;
  return copy;
endfunction
endclass

/*interface*/
interface alu_if();
  logic [7:0]in0,in1;
  logic en;
  logic [2:0] sel;
  logic [15:0]out;
endinterface
//generator class
class generator;
  transaction trans;
  mailbox#(transaction) gen2drv;
  
  function new(mailbox#(transaction) gen2drv);
    this.gen2drv=gen2drv;
    trans=new();
  endfunction
  
  task run();
    repeat(8)begin
      trans.randomize();
      gen2drv.put(trans.copy);
      #10;
      $display("time:%0t",$time);
      trans.display("[GEN]DATA SEND TO DRIVER");
    end
  endtask
endclass
/*Driver class*/
class driver;
  virtual alu_if alu_vif;
  transaction trans;
  mailbox#(transaction) gen2drv;
  
  function new(virtual alu_if alu_vif,mailbox#(transaction) gen2drv);
    this.alu_vif=alu_vif;
    this.gen2drv=gen2drv;
  endfunction
  
  task run();
    repeat(8)begin
      #15;
      gen2drv.get(trans);
      alu_vif.in0<=trans.in0;
      alu_vif.in1<=trans.in1;
      alu_vif.en<=trans.en;
      alu_vif.sel<=trans.sel;
      $display("time:%0t",$time);
      trans.display("[DRV]DRIVER RECIVED DATA FROM GENERATOR");
      trans.out=alu_vif.out;
    end
  endtask
endclass
//monitor class
class monitor;
    virtual alu_if alu_vif;
    mailbox #(transaction) mon2scb;
    function new (virtual alu_if alu_vif, mailbox #(transaction)mon2scb);
        this.alu_vif=alu_vif;
        this.mon2scb=mon2scb;
    endfunction

  task run();
    repeat(8)
      #20
        begin
          	transaction trans;
    		trans=new();
            trans.in0=alu_vif.in0;
            trans.in1=alu_vif.in1;
            trans.en=alu_vif.en;
            trans.sel=alu_vif.sel;
            trans.out=alu_vif.out;
            mon2scb.put(trans);
          $display("time:%0t",$time);
          trans.display("[MON]DATA SEND TO SCOREBOARD");
        end
    endtask
endclass
//scoreboard class
class scoreboard;
    mailbox #(transaction) mon2scb;
    parameter 	
      ADD_SEL = 3'b000,
      SUB_SEL = 3'b001,
      SHR_SEL = 3'b010,
      SHL_SEL = 3'b011,
      AND_SEL = 3'b100,
      OR_SEL =  3'b101,
      XOR_SEL = 3'b110,
      NOT_SEL = 3'b111;
    logic [15:0]y;
    string p;
    function new(mailbox#(transaction)mon2scb);
        this.mon2scb=mon2scb;
    endfunction

  task run();
    transaction trans;
    repeat(8)
        begin
          	#20;
            mon2scb.get(trans);
            if(trans.en)begin
                case (trans.sel)
                    ADD_SEL:y=trans.in0+trans.in1;
                    SUB_SEL:y=trans.in0-trans.in1;
                    SHR_SEL:y=trans.in1>>1;
                    SHL_SEL:y=trans.in0<<1;
                    AND_SEL:y=trans.in0&trans.in1;
                    OR_SEL:y=trans.in0|trans.in1;
                    XOR_SEL:y=trans.in0^trans.in1;
                    NOT_SEL:y=~trans.in0;
                endcase
            end
            else y=16'bz;
            if(y===trans.out)
            begin
                p="Pass";
            end
            else p="Fail";
            trans.out=y;
          $display("time:%0t",$time);
          trans.display({"[SCB]Data recived form MON ",p});
        end
    endtask
endclass
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

  task run();
        test();
        $finish;
    endtask
endclass
//test program
program test(alu_if alu_if);
    environment env;
    initial
    begin
        env=new(alu_if);
        env.run();
    end
  	
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endprogram
//test top module
module tb_top();
    alu_if alu_if();
    test t1(alu_if);

    alu dut(.in0(alu_if.in0),.in1(alu_if.in1),.en(alu_if.en),.sel(alu_if.sel),.out(alu_if.out));
    
endmodule
