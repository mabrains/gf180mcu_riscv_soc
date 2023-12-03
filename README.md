GlobalFoundries 180nm MCU Analog/Digital IPs for Caravel-GFMPW1
===============================================================

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

[<p align="center"><img src="/docs/mabrains.png" width="700">](http://mabrains.com/)

# Table of contents
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Prerequisites](#prerequisites)
- [Analog IPs](#analog-ips)
- [Digital IPs](#digital-ips)


## Introduction

This repository contains some analog/digital IPs implemented using Open-Source PDKs by GF180nm MCU technology for [Caravel OpenMPW shuttle](https://github.com/efabless/caravel-gf180mcu).

## Project Overview

The primary objective of this project was to implement an analog wrapper includes some IPs like Low-dropout regulators (LDO), oscillators, Band-Gap-Refrenece (BGR) and some different amplifiers using 180nm technology, each one of them has its own IOs to be tested separately. On the other hand, we have iplemented some digital periperals like USB, UART, RTC, and so on. All digital IPs have an interface to communicate with the RISCV core of the chip, each one of them has its own address and pins.

## Prerequisites

You need the following set of tools installed to be able to view and test all implemented blocks:

- ngspice 40+
- Klayout 0.28.12+ 
- OpenLane
- cocotb 1.7.2+
- Iverilog 11+
- GTKWave 3.3+

## Analog IPs

* In this shuttle, we demonstrate design of the following analog IPs:-


|No.|IP       | Layout-DRC       | Layout-LVS       | Layout-PEX       |
|---|---------| ----------       | -----------      | -----------      |
|1|**1.8v LDO** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|2|**Adjustable-LDO (1.8-5)v** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|3|**1v-BGR-LDO_1.8v** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|4|**1v-BGR-Adj_LDO** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|5|**Pass_device-LDO_1.8v** |:heavy_check_mark:|:heavy_check_mark:|:x:|
|6|**Pass_device-Adj_LDO** |:heavy_check_mark:|:heavy_check_mark:|:x:|
|7|**Error_Amp-LDO_1.8v** |:heavy_check_mark:|:heavy_check_mark:|:x:|
|8|**Error_Amp-Adj_LDO** |:heavy_check_mark:|:heavy_check_mark:|:x:|
|9|**Comparator-OpAmp** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|10|**Ring-Osc-3.3vFETs** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|11|**Ring-Osc-5.0vFETs** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|12|**XTAL-Osc-16M** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|13|**XTAL-Osc-100M** |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|


## Digital IPs

* In this shuttle, we demonstrate design of the following analog IPs:-


|No.|IP       | Layout-DRC       | Layout-LVS       |
|---|---------| ----------       | -----------      |
|1|**WB-Buttons-LEDs** |:heavy_check_mark:|:heavy_check_mark:|
|2|**Temp-Sensor** |:heavy_check_mark:|:heavy_check_mark:|
|3|**I2C** |:heavy_check_mark:|:heavy_check_mark:|
|4|**USB** |:heavy_check_mark:|:heavy_check_mark:|
|5|**SSPIM** |:heavy_check_mark:|:heavy_check_mark:|
|6|**UART0** |:heavy_check_mark:|:heavy_check_mark:|
|6|**UART1** |:heavy_check_mark:|:heavy_check_mark:|
|7|**PWM** |:heavy_check_mark:|:heavy_check_mark:|
|8|**Timer** |:heavy_check_mark:|:heavy_check_mark:|
|9|**RTC** |:heavy_check_mark:|:heavy_check_mark:|

#### SOC Memory Map

* The following table explains the SOC Memory Map

|No.|IP       | ADDR-MAP           |
|---|---------| ------------------ |
|1|**WB-Buttons-LEDs** |0x3000_0000|
|2|**Temp-Sensor** |0x3000_0008|
|3|**I2C** |0x3000_0040|
|4|**USB** |0x3000_0080|
|5|**SSPIM** |0x3000_00C0|
|6|**UART0** |0x3000_0100|
|7|**UART1** |0x3000_01C0|
|8|**PWM** |0x3000_0240|
|8|**Timer** |0x3000_0260|
|8|**RTC** |0x3000_0280|

#### USER GPIO Pins

* The following table explains the user GPIO Pins

|GPIO |Configuration      | Block           | Usage      |
|---|-------------------| --------------- | ---------- |
|GPIO_5 | INPUT_PULLUP  | WB-Buttons-LEDs | button-0   |
|GPIO_6 | INPUT_PULLUP  | WB-Buttons-LEDs | button-1   |
|GPIO_7 | OUTPUT        | WB-Buttons-LEDs | leds-0     |
|GPIO_8 | OUTPUT        | WB-Buttons-LEDs | leds-1     |
|GPIO_9 | OUTPUT        | WB-Buttons-LEDs | wb_clk_i   |
|GPIO_10| OUTPUT        | WB-Buttons-LEDs | user_clk_2 |
|GPIO_11| BIDIRECTIONAL |       -         | Empty      |
|GPIO_12| BIDIRECTIONAL |       -         | Empty      |
|GPIO_13| OUTPUT        | Temp sensor     | Display    |
|GPIO_14| OUTPUT        | Temp sensor     | Display    |
|GPIO_15| OUTPUT        | Temp sensor     | Display    |
|GPIO_16| OUTPUT        | Temp sensor     | Display    |
|GPIO_17| OUTPUT        | Temp sensor     | Display    |
|GPIO_18| OUTPUT        | Temp sensor     | Display    |
|GPIO_19| OUTPUT        | Temp sensor     | Display    |
|GPIO_20| OUTPUT        | Temp sensor     | Display    |
|GPIO_21| BIDIRECTIONAL | Periperals      | RXD[0]     |
|GPIO_22| BIDIRECTIONAL | Periperals      | TXD[0]     |
|GPIO_23| BIDIRECTIONAL | Periperals      | RXD[1]     |
|GPIO_24| BIDIRECTIONAL | Periperals      | PWM0       |
|GPIO_25| BIDIRECTIONAL | Periperals      | TXD[1]     |
|GPIO_26| BIDIRECTIONAL |      -          | Empty      |
|GPIO_27| BIDIRECTIONAL | Periperals      | SS[3]/PWM1 |
|GPIO_28| BIDIRECTIONAL | Periperals      | SS[2]/PWM2 |
|GPIO_29| BIDIRECTIONAL | Periperals      | SS[1]/PWM3 |
|GPIO_30| BIDIRECTIONAL | Periperals      | SS[0]/PWM4 |
|GPIO_31| BIDIRECTIONAL | Periperals      | MOSI/PWM5  |
|GPIO_32| BIDIRECTIONAL | Periperals      | MISO       |
|GPIO_33| BIDIRECTIONAL | Periperals      | SCK        |
|GPIO_34| BIDIRECTIONAL | Periperals      | usb_dp     |
|GPIO_35| BIDIRECTIONAL | Periperals      | usb_dn     |
|GPIO_36| BIDIRECTIONAL | Periperals      | SDA        |
|GPIO_37| BIDIRECTIONAL | Periperals      | SCL        |


## Reference

For **digital** part:

* [RISCV-Peripherals](https://github.com/dineshannayya/riscduino)
* [Temperture sensor](https://github.com/iic-jku/tt03-tempsensor)
