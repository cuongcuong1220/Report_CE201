module tb_top();
    alu_if alu_if();
    test t1(alu_if);

    alu dut(.in0(alu_if.in0),.in1(alu_if.in1),.en(alu_if.en),.sel(alu_if.sel),.out(alu_if.out));
    
endmodule