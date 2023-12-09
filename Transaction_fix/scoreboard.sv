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
    repeat(1)
        begin
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
          trans.display({"[SCB]Data recived form MON ",p});
        end
    endtask
endclass