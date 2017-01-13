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
Xeon E5-2665 CPU | $1440  
i7-6700  | $290  
i7-6700K | $300  

#### 2017 Jan ####
Xeon E5-2665 CPU | NO LONGER AVAILABLE FOR SALE  
i7-6700  | $300  
i7-6700K | $330   
i7-7700  | $310  
i7-7700K | $350  


EST BUILD COST FOR NODE REPLICATION
-----------------------------------
Xeon: $5k   + tax : (Estimated based on 2x CPU + dual mobo + avg. server req.)  
6700K: $720 + tax : https://pcpartpicker.com/list/GRQZzM  
     : $670 + tax : https://pcpartpicker.com/list/bY3qBP  
     : $635 + tax : https://pcpartpicker.com/list/PJY4BP  
     : $580 + tax : https://pcpartpicker.com/list/PY46qk  
7700 : $710 + tax : https://pcpartpicker.com/list/ydzxVY  

EST POWER for $20k cluster
--------------------------
Mathe: 25 *  65 W = 1.625 kW  
6700k: 25 *  95 W = 2.375 kW  
espin:  4 * 230 W =  .920 kW  

EST POWER COST / YEAR at $.1/kWh
--------------------------------
Mathe: 1.625 kW => 1.625 * .1 * 24 * 365 = $1423.50  
6700k: 2.375    =>                         $2080.50  
espin:  .920    =>                         $ 805.92  

EST EFF. of CPU HOUR CHARGED PER TIME LOOP
------------------------------------------
Mathe: 28  loops/sec * 3600 sec/hour /  4 threads = 25200 loops / (thread HOUR)  
ESPIN: 4.5 loops/sec * 3600 sec/hour / 16 threads =  1013 loops / (thread HOUR)  

Not only is Espina ~7x slower, but running on 16 threads leads to Espina
costing cluster users ~25x more cpuhours relative to 4 threads on Mathe.

MOST PROFITABLE CLUSTER for CLUSTER OWNER: ESPINA
