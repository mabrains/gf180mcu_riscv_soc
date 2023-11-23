module analog_wrapper (in1,
    in2,
    out,
    vdd,
    vss);
 input in1;
 input in2;
 output out;
 input vdd;
 input vss;


 gf180mcu_fd_sc_mcu7t5v0__and2_1 _0_ (.A1(in2),
    .A2(in1),
    .Z(out),
    .VDD(vdd),
    .VNW(vdd),
    .VPW(vss),
    .VSS(vss));
endmodule
