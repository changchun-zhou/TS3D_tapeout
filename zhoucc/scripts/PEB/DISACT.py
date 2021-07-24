import numpy as np
import random
import os

def DISACT( 
            REGFLGACT, REGACT, cnt_Flag_hex, cnt_act_hex,
            FlagActFile, ActFile, 
            Len, NumChn, NumBlk, cntfrm ):
    # *************************************************************************
    for b in range(NumBlk):
        for i in range (NumChn*Len*Len): 
            if cnt_Flag_hex == 32:
                cnt_Flag_hex = 1
                FlagActFile.read(1)
            else:
                cnt_Flag_hex += 1
            REGFLGACT[i + NumChn*Len*Len*b] = FlagActFile.read(1)
        

    for i in range (0, NumChn*Len*Len*NumBlk): # density 0.2
        if cnt_act_hex == 16:
            cnt_act_hex =1
            ActFile.read(1)
        else:
            cnt_act_hex += 1
        REGACT[i + NumChn*Len*Len*NumBlk*cntfrm] = ActFile.read(4)

    return  REGFLGACT, REGACT, cnt_Flag_hex, cnt_act_hex