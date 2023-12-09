/*Transaction class*/
class transaction;
  randc logic [7:0] in0,in1;
  randc logic en;
  randc bit [2:0]sel;
  logic [15:0]out;
  
  /*constraint in0_greater_than_in1 {
    in0 > in1;
  }*/
  function void display(string name);
    $display("-----------------------------------------");
    $display("%s",name);
    $display("enable: %d,select: %b,input0: %d,input1: %d,output:%d",en,sel,in0,in1,out);
    $display("-----------------------------------------");
  endfunction
  //deep copy edit at 10PM 23/11
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