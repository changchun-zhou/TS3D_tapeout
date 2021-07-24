import numpy as np
import random
import os

GBPOOL_dataFile = open("dump_rtl/GBPOOL_data.txt", "r")
BF_dataFile = open("dump_rm/BF_data.txt", "w")
BF_flgFile = open("dump_rm/BF_flg.txt", "w")
Scale_y = 1
Quant_shift = 0
Bias_y = 0


def POOL ( GBPOOL_dataFile, BF_dataFile, BF_flgFile, Scale_y, Quant_shift, Bias_y ):
    PSUM     = [[ 0 for x in range(16) ] for y in range(16*16)]
    POOL_MEM = [[[ 0 for x in range(16) ] for y in range(16)] for z in range(16) ]
    for i in range(14):
        for j in range(14):
            for chn in range(16):
                PSUM[14*i + j][chn] = int(GBPOOL_dataFile.read(12))
            GBPOOL_dataFile.read(1) # \n
    for i in range(7):
        for j in range(7):
            for x in range(2):
                for y in range(2):
                    for chn in range(16):
                        Output_Quant = PSUM[28*i+4*j+2*x+y][chn]*Scale_y/2**Quant_shift + Bias_y
                        if Output_Quant > 0 :
                            ReLU_tmp = '{:032b}'.format(Output_Quant)
                            ReLU = int(ReLU_tmp[25:32], 2) # 7 bits
                        else:
                            ReLU = 0
                        if POOL_MEM[i][j][chn] < ReLU:
                            POOL_MEM[i][j][chn] = ReLU # pooling
    for i in range(7):
        for j in range(7):
            for chn in range(16):
                if POOL_MEM[i][j][chn] > 0 :
                    BF_dataFile.write("%4d"%POOL_MEM[i][j][chn])
                    BF_dataFile.write("\n")
                    BF_flgFile.write("1")
                else:
                    BF_flgFile.write("0")
            BF_flgFile.write("\n")
POOL( GBPOOL_dataFile, BF_dataFile, BF_flgFile, Scale_y, Quant_shift, Bias_y )





