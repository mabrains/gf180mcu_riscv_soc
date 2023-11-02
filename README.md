<img align="right" src="https://svg.wavedrom.com/{signal:[{wave:'0.P...'},{wave:'023450',data:'S E R V'}]}"/>

# SERV

SERV is an award-winning bit-serial RISC-V core

In fact, the award-winning SERV is the world's smallest RISC-V CPU. It's the perfect companion whenever you need a bit of computation and silicon real estate is at a premium.

SERV is an award-winning bit-serial RISC-V core

In fact, the award-winning SERV is the world's smallest RISC-V CPU. It's the perfect companion whenever you need a bit of computation and silicon real estate is at a premium.

How small is it then? Synthesizing the latest version of SERV in its most minimal form, yields the following results for some popular FPGA architectures and a typical CMOS process.

| Lattice iCE40 | Intel Cyclone 10LP | AMD Artix-7 | CMOS   |
| ------------- | ------------------ | ----------- | ------ |
| 198 LUT       | 239 LUT            | 125 LUT     | 2.1kGE |
| 164 FF        | 164 FF             | 164 FF      |        |


If you want to know more about SERV, what a bit-serial CPU is and what it's good for, I recommend starting out by watching the fantastic short SERV movies
* [introduction to SERV](https://www.award-winning.me/serv-introduction/)
* [SERV : RISC-V for a fistful of gates](https://www.award-winning.me/serv-for-a-fistful-of-gates/)
* [SERV: 32-bit is the New 8-bit](https://www.award-winning.me/serv-32-bit-is-the-new-8-bit/)
* [Bit by bit - How to fit 8 RISC V cores in a $38 FPGA board (presentation from the Zürich 2019 RISC-V workshop)](https://www.youtube.com/watch?v=xjIxORBRaeQ)

All SERV videos and more can also be found [here](https://www.award-winning.me/videos/).

Apart from being the world's smallest RISC-V CPU, SERV also aims at being the best documented RISC-V CPU. For this there is an official [SERV user manual](https://serv.readthedocs.io/en/latest/#) with block diagrams that are correct to the gate-level, cycle-accurate timing diagrams and an in-depth description of how things work.

## Systems using SERV

SERV can be easily integrated into any design, but if you are looking at just quickly trying it out, here is a list of some systems that are already using SERV:

[Servant](https://serv.readthedocs.io/en/latest/servant.html) is the reference platform for SERV. It is a very basic SoC that contains just enough runs Zephyr RTOS. Servant is intended for FPGAs and has been ported to around 20 different FPGA boards. It is also used to run the RISC-V regression test suite.

[CoreScore](https://corescore.store/) is an award-giving benchmark for FPGAs and their synthesis/P&R tools. It tests how many SERV cores that can be put into a particular FPGA.

[Observer](https://github.com/olofk/observer) is a configurable and software-programmable sensor aggregation platform for heterogenous sensors.

[Subservient](https://github.com/olofk/subservient/) is a small technology-independent SERV-based SoC intended for ASIC implementations together with a single-port SRAM.

[Litex](https://github.com/enjoy-digital/litex) is a Python-based framework for creating FPGA SoCs. SERV is one of the 30+ supported cores. A Litex-generated SoC has been used to run DooM on SERV.
