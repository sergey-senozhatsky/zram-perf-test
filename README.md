#
# Sergey Senozhatsky. sergey.senozhatsky@gmail.com
#

# zram-perf-test
zram performance testing toolset

LOG_SUFFIX=
	The suffix the test result file must contain:
	/tmp/test-fio-zram-$LOG_SUFFIX

USE_MEM_HOGGER=
	Start a memory hogger app in the backgroud

EXTENDED_LOG=
	Record an extended stats (mm_stat, buddyinfo, etc.)

ZRAM_SIZE=
	The size of the zram device (e.g. 3G, 512M)

MAX_ITER=
	The number of fio iterations. On each iteration the
	test increases the number of fio jobs, files to create,
	etc.

FIO_LOOPS=
	The number of loop fio must execute for every test.

FIO_TEST=
	Specifies the fio template file to be used.
	E.g.
		FIO_TEST=compbuf -- will switch to conf/fio-template-compressed-buffer
				    file
	Otherwise, the conf/fio-template-static-buffer file will be used.

	The main difference between those two templates is that 'static-buffer'
	sets a `buffer_pattern=0xbadc0ffee' fio option, while `compressed-buffer'
	replaces this option with `buffer_compress_percentage=11'. See fio documentation
	for more details.


EXAMPLE
----------------------------------------------------------------------------------------------------

== Run the test:

ZRAM_SIZE=1G LOG_SUFFIX=-old-lzo ./zram-fio-test.sh

== Update zram, etc. Run the test:

ZRAM_SIZE=1G LOG_SUFFIX=-crypto-lzo ./zram-fio-test.sh

== Compare the perf logs (can be 2+ files)

./fio-perf-o-meter.sh /tmp/test-fio-zram--old-lzo /tmp/test-fio-zram--crypto-lzo


Processing /tmp/test-fio-zram--old-lzo
Processing /tmp/test-fio-zram--crypto-lzo
#jobs1                         	                
READ:           2432.4MB/s	 2481.5MB/s
READ:           2026.4MB/s	 2033.1MB/s
WRITE:          1378.9MB/s	 1358.1MB/s
WRITE:          1088.1MB/s	 1080.1MB/s
READ:           434571KB/s	 434571KB/s
WRITE:          435375KB/s	 435375KB/s
READ:           404382KB/s	 400774KB/s
WRITE:          404703KB/s	 401093KB/s
#jobs2                         	                
READ:           7777.3MB/s	 7989.7MB/s
READ:           6872.5MB/s	 6934.6MB/s
WRITE:          3388.9MB/s	 3400.2MB/s
WRITE:          2925.8MB/s	 2881.9MB/s
READ:           1024.5MB/s	 1014.3MB/s
WRITE:          1022.6MB/s	 1012.9MB/s
READ:           986241KB/s	 971908KB/s
WRITE:          987858KB/s	 973501KB/s
#jobs3                         	                
READ:           13376MB/s	 13357MB/s
READ:           11578MB/s	 11785MB/s
WRITE:          4842.9MB/s	 4772.7MB/s
WRITE:          4187.2MB/s	 4136.5MB/s
READ:           1451.1MB/s	 1447.4MB/s
WRITE:          1455.4MB/s	 1450.8MB/s
READ:           1392.6MB/s	 1386.7MB/s
WRITE:          1391.8MB/s	 1385.1MB/s
#jobs4                         	                
READ:           20078MB/s	 19851MB/s
READ:           17356MB/s	 17430MB/s
WRITE:          6403.4MB/s	 6423.5MB/s
WRITE:          5636.8MB/s	 5634.2MB/s
READ:           1996.4MB/s	 1985.9MB/s
WRITE:          1992.3MB/s	 1981.4MB/s
READ:           1926.9MB/s	 1917.9MB/s
WRITE:          1923.1MB/s	 1914.1MB/s
#jobs5                         	                
READ:           19394MB/s	 19794MB/s
READ:           18199MB/s	 18528MB/s
WRITE:          6318.4MB/s	 6054.4MB/s
WRITE:          5607.9MB/s	 5571.3MB/s
READ:           1941.2MB/s	 1956.4MB/s
WRITE:          1939.8MB/s	 1954.6MB/s
READ:           1880.7MB/s	 1912.5MB/s
WRITE:          1872.2MB/s	 1903.8MB/s
#jobs6                         	                
READ:           21260MB/s	 21358MB/s
READ:           19650MB/s	 19609MB/s
WRITE:          6580.6MB/s	 6559.5MB/s
WRITE:          5963.2MB/s	 5718.1MB/s
READ:           2031.7MB/s	 2012.2MB/s
WRITE:          2023.9MB/s	 2004.5MB/s
READ:           1981.4MB/s	 1971.2MB/s
WRITE:          1977.5MB/s	 1967.4MB/s
#jobs7                         	                
READ:           21249MB/s	 21228MB/s
READ:           19783MB/s	 19321MB/s
WRITE:          6779.3MB/s	 6665.9MB/s
WRITE:          6145.8MB/s	 6052.4MB/s
READ:           2054.2MB/s	 2089.7MB/s
WRITE:          2049.7MB/s	 2085.5MB/s
READ:           2038.3MB/s	 1995.1MB/s
WRITE:          2034.5MB/s	 1992.3MB/s
#jobs8                         	                
READ:           20111MB/s	 20311MB/s
READ:           18576MB/s	 18618MB/s
WRITE:          7045.9MB/s	 7029.8MB/s
WRITE:          6298.4MB/s	 6309.7MB/s
READ:           2129.3MB/s	 2137.2MB/s
WRITE:          2125.9MB/s	 2133.1MB/s
READ:           2066.5MB/s	 2072.8MB/s
WRITE:          2079.3MB/s	 2085.7MB/s
#jobs9                         	                
READ:           19763MB/s	 19962MB/s
READ:           18432MB/s	 18543MB/s
WRITE:          6779.8MB/s	 6862.3MB/s
WRITE:          6243.9MB/s	 6282.2MB/s
READ:           2123.3MB/s	 2134.8MB/s
WRITE:          2129.7MB/s	 2141.2MB/s
READ:           2071.6MB/s	 2059.8MB/s
WRITE:          2077.1MB/s	 2066.2MB/s
#jobs10                        	                
READ:           19922MB/s	 20105MB/s
READ:           18800MB/s	 18596MB/s
WRITE:          7024.1MB/s	 6994.6MB/s
WRITE:          6498.9MB/s	 6446.2MB/s
READ:           2146.6MB/s	 2138.5MB/s
WRITE:          2157.8MB/s	 2149.7MB/s
READ:           2103.9MB/s	 2084.5MB/s
WRITE:          2106.7MB/s	 2087.2MB/s
jobs1                              perfstat         	                          
stalled-cycles-frontend      21,489,830,802 (  43.56%)	   23,414,672,161 (  47.21%)
stalled-cycles-backend        9,981,282,479 (  20.23%)	    9,869,828,602 (  19.90%)
instructions                 57,055,302,552 (    1.16)	   57,142,098,427 (    1.15)
branches                     11,352,209,696 ( 728.915)	   11,369,877,932 ( 727.296)
branch-misses                    68,360,727 (   0.60%)	       68,404,447 (   0.60%)
jobs2                              perfstat         	                          
stalled-cycles-frontend      28,600,769,282 (  38.25%)	   31,643,085,550 (  42.03%)
stalled-cycles-backend       13,827,097,555 (  18.49%)	   13,488,568,072 (  17.92%)
instructions                 92,982,247,030 (    1.24)	   93,151,167,916 (    1.24)
branches                     18,283,685,883 ( 772.002)	   18,322,372,063 ( 768.299)
branch-misses                    76,944,199 (   0.42%)	       78,690,215 (   0.43%)
jobs3                              perfstat         	                          
stalled-cycles-frontend      45,107,072,849 (  44.76%)	   45,747,963,107 (  45.15%)
stalled-cycles-backend       16,296,051,170 (  16.17%)	   16,476,301,082 (  16.26%)
instructions                128,845,326,509 (    1.28)	  129,114,406,034 (    1.27)
branches                     25,211,232,920 ( 695.345)	   25,276,046,319 ( 693.435)
branch-misses                    95,336,315 (   0.38%)	       97,253,370 (   0.38%)
jobs4                              perfstat         	                          
stalled-cycles-frontend      47,839,054,311 (  36.94%)	   56,603,176,137 (  43.57%)
stalled-cycles-backend       23,897,774,062 (  18.45%)	   22,466,749,945 (  17.29%)
instructions                165,066,064,332 (    1.27)	  165,375,734,889 (    1.27)
branches                     32,220,433,474 ( 690.592)	   32,292,082,938 ( 690.024)
branch-misses                   107,903,162 (   0.33%)	      106,563,208 (   0.33%)
jobs5                              perfstat         	                          
stalled-cycles-frontend      71,504,477,111 (  45.48%)	   71,878,429,136 (  45.68%)
stalled-cycles-backend       26,541,605,642 (  16.88%)	   26,025,720,137 (  16.54%)
instructions                201,668,245,249 (    1.28)	  202,003,248,684 (    1.28)
branches                     39,329,858,417 ( 698.208)	   39,387,391,093 ( 697.417)
branch-misses                   130,620,405 (   0.33%)	      133,851,180 (   0.34%)
jobs6                              perfstat         	                          
stalled-cycles-frontend      66,130,834,671 (  36.20%)	   80,161,836,716 (  43.52%)
stalled-cycles-backend       32,527,273,707 (  17.80%)	   31,136,902,197 (  16.90%)
instructions                237,544,751,513 (    1.30)	  237,980,152,797 (    1.29)
branches                     46,244,135,434 ( 703.898)	   46,371,300,070 ( 700.583)
branch-misses                   129,763,491 (   0.28%)	      124,008,362 (   0.27%)
jobs7                              perfstat         	                          
stalled-cycles-frontend      96,011,096,236 (  45.55%)	   97,505,729,341 (  45.91%)
stalled-cycles-backend       35,075,088,633 (  16.64%)	   35,711,751,768 (  16.82%)
instructions                273,684,148,450 (    1.30)	  274,049,581,214 (    1.29)
branches                     53,226,557,414 ( 701.444)	   53,348,962,263 ( 698.009)
branch-misses                   154,554,127 (   0.29%)	      154,268,650 (   0.29%)
jobs8                              perfstat         	                          
stalled-cycles-frontend      88,177,251,162 (  36.83%)	  103,535,913,727 (  43.35%)
stalled-cycles-backend       44,921,182,223 (  18.76%)	   41,112,561,205 (  17.21%)
instructions                309,064,880,320 (    1.29)	  309,601,850,537 (    1.30)
branches                     60,082,434,428 ( 696.538)	   60,209,294,961 ( 699.665)
branch-misses                   146,506,310 (   0.24%)	      143,133,935 (   0.24%)
jobs9                              perfstat         	                          
stalled-cycles-frontend     126,405,421,763 (  46.82%)	  126,381,115,384 (  46.79%)
stalled-cycles-backend       48,186,518,384 (  17.85%)	   47,805,024,235 (  17.70%)
instructions                345,120,620,559 (    1.28)	  345,665,762,319 (    1.28)
branches                     67,117,972,931 ( 690.277)	   67,245,106,539 ( 691.142)
branch-misses                   171,595,740 (   0.26%)	      175,971,047 (   0.26%)
jobs10                             perfstat         	                          
stalled-cycles-frontend     108,499,127,092 (  36.77%)	  129,827,826,624 (  43.88%)
stalled-cycles-backend       56,475,608,845 (  19.14%)	   53,014,780,068 (  17.92%)
instructions                380,780,129,219 (    1.29)	  381,483,929,727 (    1.29)
branches                     73,960,230,572 ( 695.824)	   74,130,895,621 ( 695.446)
branch-misses                   173,715,569 (   0.23%)	      172,580,996 (   0.23%)
seconds elapsed        17.051715648	17.086316115
seconds elapsed        13.255099832	13.495843677
seconds elapsed        13.474066502	13.695139647
seconds elapsed        13.362502512	13.388860863
seconds elapsed        16.476014118	16.514753664
seconds elapsed        18.547854105	18.771483547
seconds elapsed        20.866319217	21.225159845
seconds elapsed        23.216923356	23.107110780
seconds elapsed        26.062994594	26.116991016
seconds elapsed        28.416572933	28.463931431
