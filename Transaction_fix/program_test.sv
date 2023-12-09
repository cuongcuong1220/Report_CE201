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