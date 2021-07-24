import numpy as np
import random
import os

def DISWEI(   
            REGFLGWEI, REGWEI, cnt_Flagwei_hex, cntwei,
            FlagWeiFile, IDWeiFile, WeiFile, 
            NumWei,NumChn,NumBlk,MaxDepth ):
    for b in range (NumBlk):
        for j in range (NumWei + 1) : #28
            for k in range ( NumChn ) :
                if cnt_Flagwei_hex == 64:
                    cnt_Flagwei_hex = 1
                    FlagWeiFile.read(1) # \n read
                else:
                    cnt_Flagwei_hex += 1
                REGFLGWEI[j][k + NumChn*b] = FlagWeiFile.read(1) # FlgWei0 FlgWei1

    for j in range ( 0, NumWei*MaxDepth ): # 
        IDWei = IDWeiFile.read(3)
        if IDWei.strip() == '' :
            break
        IDWei = int(IDWei)
        IDWeiFile.read(2) # \n
        for k in range (0, 16):
            REGWEI[IDWei][cntwei[IDWei]] = int(WeiFile.read(4))
            cntwei[IDWei] += 1
        WeiFile.read(1) # \n read

    return REGFLGWEI, REGWEI, cnt_Flagwei_hex, cntwei
