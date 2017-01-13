Computational Timing Notes
==========================

Espina, full machine working on problem: 16 threads: 4.5 loops / sec

Mathe (condor nodes), full machine working on problem: 4 threads: 28 loops / sec

Espina: 2 x Intel Xeon E5-2665 CPU with 8 physical, 16 logical threads per CPU  
Mathe: Intel i7-6700 with 4 physical, 8 logical threads   

Espina: 32 GB RAM  
Mathe:  16 GB RAM  

Espina: HDD  
Mathe : HDD  

Espina: 115 W x 2 = 230 W  
Mathe : 65 W  
6700K : 95 W  

NOTE
----

At the time of the writing of these notes (2016 Nov), the i7-7700 was not
released and the PC parts were priced as summarized.

The i7-6700K does not seem to be beneficial over the i7-6700 without
overclocking due to the near 50% increase in power requirements.

The i7-7700 does seem to be beneficial over the i7-6700 as it uses the same
power but delivers higher clock speeds (5% increase) at the same price. The
i7-7700 also supports faster RAM (12% increase).

Currently, an i7-7700 build is more expensive than a i7-6700 build, but this is
mostly due to the newer motherboard that the i7-7700 requires. Those prices
should come down by Q2 of 2017.

intel ark i7-6700: https://ark.intel.com/products/88196/Intel-Core-i7-6700-Processor-8M-Cache-up-to-4_00-GHz  
intel ark i7-7700: https://ark.intel.com/products/97128/Intel-Core-i7-7700-Processor-8M-Cache-up-to-4_20-GHz  

intel ark Xeon E5-2665: https://ark.intel.com/products/64597/Intel-Xeon-Processor-E5-2665-20M-Cache-2_40-GHz-8_00-GTs-Intel-QPI  

COSTS
-----

#### 2016 Nov ####
         CPU | Cost
-------------|------
Xeon E5-2665 | $1440  
    i7-6700  | $290  
    i7-6700K | $300  

#### 2017 Jan ####
         CPU | Cost
-------------|-----------------------------
Xeon E5-2665 | NO LONGER AVAILABLE FOR SALE  
    i7-6700  | $300  
    i7-6700K | $330   
    i7-7700  | $310  
    i7-7700K | $350  


EST BUILD COST FOR NODE REPLICATION
-----------------------------------
 CPU | COST (pre tax) | link
-----|----------------|--------------------------------------------------------
Xeon | $5k            | (Estimated based on 2x CPU + dual mobo + avg. server req.)  
6700K| $720           | https://pcpartpicker.com/list/GRQZzM  
     | $670           | https://pcpartpicker.com/list/bY3qBP  
     | $635           | https://pcpartpicker.com/list/PJY4BP  
     | $580           | https://pcpartpicker.com/list/PY46qk  
7700 | $710           | https://pcpartpicker.com/list/ydzxVY  

EST POWER for $20k cluster
--------------------------
Cluster | Est. Nodes | Node (W) | Cluster (kW)| $/Year (assuming $.10 kWh)
--------|------------|----------|-------------|-----------------------------
 Mathe  |     25     |     65   |   1.625     | $1423.50
 6700k  |     25     |     95   |   2.375     | $2080.50
 Espina |      4     |    230   |    .920     |  $805.92

EST EFF. of CPU HOUR CHARGED PER TIME LOOP
------------------------------------------
Mathe: 28  loops/sec * 3600 sec/hour /  4 threads = 25200 loops / (thread HOUR)  
ESPIN: 4.5 loops/sec * 3600 sec/hour / 16 threads =  1013 loops / (thread HOUR)  

Not only is Espina ~7x slower, but running on 16 threads leads to Espina
costing cluster users ~25x more cpuhours relative to 4 threads on Mathe.

MOST PROFITABLE CLUSTER for CLUSTER OWNER: ESPINA

CPU Study
=========

The following table was collected from [geekbench 3](https://browser.primatelabs.com/geekbench3/search)
 and from prices listed on [pc part picker](https://pcpartpicker.com/).
See pdf in fig/ directory for results.

BN        | P | C |TDP| L1KB | L2KB |  L3KB | MCS  | DMSC | DMMC | MPSC | MPMC | $ 
---------:|--:|--:|--:|-----:|-----:|------:|-----:|-----:|-----:|-----:|-----:|----:
i7-870    | 1 | 4 | 95| 128  | 1024 |  8192 | 10711| 4.73 | 21.5 | 2358 | 2473 | 230 
i7-875K   | 1 | 4 | 95| 128  | 1024 |  8192 | 10711| 4.93 | 21.9 | 2180 | 2729 | 340
i7-960    | 1 | 4 |130| 128  | 1024 |  8192 | 10121| 4.03 | 18.0 | 2948 | 3595 | 320
i7-3770K  | 1 | 4 | 77| 128  | 1024 |  8192 | 15856| 6.65 | 28.6 | 3436 | 3673 | 480
i7-4770   | 1 | 4 | 84| 128  | 1024 |  8192 | 14190| 5.74 | 25.0 | 3295 | 3639 | 320
i7-4770K  | 1 | 4 | 84| 128  | 1024 |  8192 | 16528| 6.66 | 30.9 | 4127 | 4977 | 350
i7-4790K  | 1 | 4 | 88| 128  | 1024 |  8192 | 18913| 7.53 | 35.1 | 4406 | 5042 | 370
i7-5820K  | 1 | 6 |140| 192  | 1536 | 15360 | 27540| 8.05 | 47.8 | 4320 | 7157 | 390
i7-6700   | 1 | 4 | 65| 128  | 1024 |  8192 | 20888| 6.13 | 31.2 | 6995 | 7632 | 300
i7-6700K  | 1 | 4 | 91| 128  | 1024 |  8192 | 20443| 8.00 | 37.3 | 5421 | 5921 | 330
i7-6800K  | 1 | 6 |140| 192  | 1536 | 15360 | 22761| 6.52 | 44.8 | 3463 | 6214 | 440
i7-6850K  | 1 | 6 |140| 192  | 1536 | 15360 | 28972| 7.68 | 52.8 | 3459 | 6405 | 600
E5-1620v4 | 1 | 4 |140| 128  | 1024 | 10240 | 14746| 5.50 | 24.3 | 2745 | 4901 | 310
E5-1630v3 | 1 | 4 |140| 128  | 1024 | 10240 | 14610| 5.71 | 25.0 | 3125 | 4075 | 400
E5-2620   | 2 | 6 | 95| 192  | 1536 | 15360 | 21854| 3.03 | 42.1 | 2273 | 4586 | 400
E5-2620v2 | 2 | 6 | 80| 192  | 1536 | 15360 | 25983| 4.52 | 53.4 | 2145 | 5327 | 410
E5-2620v3 | 2 | 6 | 85| 192  | 1536 | 15360 | 30982| 5.71 | 55.2 | 3233 | 6504 | 440
E5-2620v4 | 2 | 8 | 85| 256  | 2048 | 20480 | 30221| 3.54 | 64.5 | 1978 | 2493 | 440
E5-2623v3 | 2 | 4 |105| 128  | 1024 | 10240 | 22960| 3.14 | 25.4 | 2690 | 3534 | 530
E5-2623v3 | 2 | 4 |105| 128  | 1024 | 10240 | 22960| 3.14 | 25.4 | 2690 | 3534 | 530
C2D E8400 | 1 | 2 | 65|  64  |   64 |  6144 |  3268| 2.12 | 4.12 |  597 |  564 |  15
AthX4 845 | 1 | 4 | 65| 128  | 2048 |     0 |  8600| 3.47 | 12.4 | 2312 | 3050 |  70
FX-6350   | 1 | 3 | 95|  96  | 6144 |  8192 | 11661| 3.91 | 21.1 | 2066 | 2661 | 120
FX-8350   | 1 | 4 |125| 128  | 8192 |  8192 | 18631| 4.75 | 34.3 | 2566 | 3240 | 150
FX-9590   | 1 | 4 |220| 128  | 8192 |  8192 | 21122| 5.49 | 39.7 | 3052 | 3726 | 190
