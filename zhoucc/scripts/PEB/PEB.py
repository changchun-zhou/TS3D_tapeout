import numpy as np
import random
import os
import PEC
# import POOL
import DISWEI
import DISACT
# import Statistic
#*********** read files *******************************************
# FlagActFileName = '../Data/dequant_data/prune_quant_extract_high/Activation_45_pool3b_flag.dat'
# ActFileName = '../Data/dequant_data/prune_quant_extract_high/Activation_45_pool3b_data.dat'
# FlagWeiFileName = '../Data/dequant_data/prune_quant_extract_high/Weight_45_conv4a.float_weight_flag.dat'
# WeiFileName = '../Data/dequant_data/prune_quant_extract_high/Weight_45_conv4a.float_weight_data.dat'
FlagActFileName = '../../sim_TS3D/dump_rtl/PEB/GBFLGACT_data_PEB00.txt'
ActFileName     = '../../sim_TS3D/dump_rm/ActDFile.txt'
FlagWeiFileName = '../../sim_TS3D/dump_rtl/PEB/GBFLGWEI_Data_PEB00.txt'
IDWeiFileName   = '../../sim_TS3D/dump_rtl/PEB/GBWEI_IDWei_PEB00.txt'
WeiFileName     = '../../sim_TS3D/dump_rtl/PEB/GBWEI_Data_PEB00.txt'

NumChn = 32
MaxDepth = 64
NumWei = 27
NumBlk = 1
NumFrm = 1
NumPat = 1
NumFtrGrp = 1
NumLay = 1
KerSize = 3
Stride = 2
fl = 0

NumPEC = 3
NumPEB = 1
Len = 16

PORT_DATAWIDTH = 96
# PSUM_WIDTH = 23

cnt_Flag_hex = 0
cntActError = 0
cnt_act_hex = 0
cnt_act_col = 0
POOL_ValIFM = 1

FlagActFile = open (FlagActFileName,'r')
ActFile     = open (ActFileName,    'r')
FlagWeiFile = open(FlagWeiFileName, 'r')
IDWeiFile   = open(IDWeiFileName, 'r')
WeiFile     = open(WeiFileName, 'r')


cnt_ACT = 0
cnt_Flag = 0 # continously save one frame by one frame
GBFFLGOFM_DatRd = ""
GBFOFM_DatRd = ""
FlgAct_hex = ''
cnt_wei = 0
cnt_GBFFLGACT = 0
cnt_PECMACFLGACT = 0
GBFFLGACT = ""
cntPat_last = -1

cnt_GBFACT = 0
GBFACT = ""
cntPat_last_GBFACT = -1
#cntPat_GBFACT = 0

cnt_GBFWEI = 0;
cnt_GBFFLGWEI = 0;
#cntPat_GBFWEI = 0
cntPat_last_GBFWEI = -1
cntPat_last_GBFFLGWEI = -1

ColWei = 0
cnt_Flagwei_hex = 0

REGWEI      = [[[[ 0 for x in range (0,MaxDepth)] for y in range(0, NumWei+1) ] \
                      for m in range(NumPEB   ) ] for o in range(NumFtrGrp )]
cntwei      = [[[ 0 for y in range(0, NumWei) ] \
                      for m in range(NumPEB   ) ] for o in range(NumFtrGrp )]
REGFLGWEI   = [[[[ 0 for x in range (0,MaxDepth)] for y in range(0, NumWei + 1) ] \
                      for m in range(NumPEB   ) ] for o in range(NumFtrGrp )]

# for cntLay in range(0, NumLay):

for cntFtrGrp in range( NumFtrGrp):
    # same weight per frame/patch: 3 frameS of FtrGrp(3 PEC)
    # 0 2 4 6
    # for cntBlk in range (0, NumBlk ):

        for cntPEB in range(0, NumPEB):
            # for cntPEC in range (0, NumPEC):

                # All channels' weight
                # get REGWEI[cntFtrGrp][cntPEB][numwei][MaxDepth]'s 
                # get REGFLGWEI[cntFtrGrp][cntPEB][numwei][MaxDepth]
                REGFLGWEI[cntFtrGrp][cntPEB], REGWEI[cntFtrGrp][cntPEB],cnt_Flagwei_hex, cntwei[cntFtrGrp][cntPEB] = \
                    DISWEI.DISWEI(   
                                    REGFLGWEI[cntFtrGrp][cntPEB], REGWEI[cntFtrGrp][cntPEB],cnt_Flagwei_hex, cntwei[cntFtrGrp][cntPEB],
                                    FlagWeiFile, IDWeiFile, WeiFile, 
                                    NumWei, NumChn,NumBlk, MaxDepth )

REGACT      = [[ 0 for x in range (0,NumChn*Len*Len*NumBlk*NumFrm)] for o in range (NumPat)] 
REGFLGACT   = [[[ 0 for x in range (0,NumChn*Len*Len*NumBlk)] for n in range (NumFrm)] 
                    for o in range (NumPat)]    
for cntPat in range(NumPat):# 
    for cntfrm in range(NumFrm):
        # for cntBlk in range (NumBlk ):
        #     #Fetch a block activation
        #     for actrow in range(Len) :
        #         for actcol in range(Len):
                    # get REGACT[cntPat][cntfrm][blk*row*col*chn]
                    # get REGFLGACT[cntPat][cntfrm][]
                    REGFLGACT[cntPat][cntfrm], REGACT[cntPat], cnt_Flag_hex, cnt_act_hex = \
                        DISACT.DISACT( 
                        REGFLGACT[cntPat][cntfrm], REGACT[cntPat], cnt_Flag_hex, cnt_act_hex,
                        FlagActFile, ActFile,
                        Len, NumChn, NumBlk,cntfrm, )

# for cntLay in range(0, NumLay):
for cntPEB in range(NumPEB):
    for cntPEC in range(NumPEC):
        path = "../../sim_TS3D/dump_rm/PEB/PSUMGB_data"+str(cntPEB)+"_"+str(cntPEC)+"_py.txt" 
        if os.path.exists(path):  # 如果文件存在
            # 删除文件，可使用以下两种方法。
            os.remove(path)  

AddrBlockWei_all = [[[[ 0 for x in range(9)] for y in range(NumPEC)] for z in range(NumPEB) ] for m in range(NumFtrGrp+1)]
AddrBlockWei_tmp = [[[ 0 for x in range(9)] for y in range(NumPEC)] for z in range(NumPEB) ]

AddrBlockAct_all = [[ 0 for x in range((NumBlk+ 1)*NumFrm)]  for z in range(NumPat)]
for cntFtrGrp in range( NumFtrGrp): # 4 FtrGrp 
    for cntPat in range(NumPat):# 1 patch
        FRMPOOL = [[[ 0 for x in range(NumPEB)] for y in range (Len-2)] for z in range(Len-2)]
        DELTA   = [[[ 0 for x in range(NumPEB)] for y in range (Len-2)] for z in range(Len-2)]
        
        for cntfrm in range(NumFrm):
            for cntPEB in range(NumPEB):
                for cntPEC in range(NumPEC):
                    for cntwei in range(9):
                        # every weight's addrbase in every block
                        # reset this ftrgrp's all weights
                        AddrBlockWei_tmp[cntPEB][cntPEC][cntwei] = AddrBlockWei_all[cntFtrGrp][cntPEB][cntPEC][cntwei] 
            
            for cntBlk in range (NumBlk ):
                # not accum
                PSUMGB_data = [[[[ [ 0 for x in range (0,Len)] for y in range(0, Len) ]for z in range(0, NumPEC)] for m in range(0,NumPEB)] for n in range(0,NumBlk)]

                for cntPEB in range(NumPEB):
                    for cntPEC in range (NumPEC):
                        AddrBlockAct_tmp = AddrBlockAct_all[cntPat][cntBlk + NumBlk*cntfrm]
                        # get PSUMGB_data, PSUM1, PSUM2.
                        # get 14 x 3 actrow*wei
                        # ***************** PEC **********************************************************
                        PSUMGB_data[cntBlk][cntPEB][cntPEC],  AddrBlockAct_tmp, AddrBlockWei_tmp[cntPEB][cntPEC] = \
                        PEC.PEC(REGFLGWEI[cntFtrGrp][cntPEB], REGWEI[cntFtrGrp][cntPEB], REGFLGACT[cntPat][cntfrm], REGACT[cntPat],
                                    PSUMGB_data[cntBlk][cntPEB][cntPEC],  AddrBlockAct_tmp, AddrBlockWei_tmp[cntPEB][cntPEC],
                                    Len, NumWei/3, NumChn, cntBlk, cntPEC)
                        with open ("../../sim_TS3D/dump_rm/PEB/PSUMGB_data"+str(cntPEB)+"_"+str(cntPEC)+"_py.txt",'a+') as PSUMGB_data_File:
                            for actrow in range(1, Len -1): # dump 14 rows
                                for actcol in range(Len): # dump 16 cols
                                    PSUMGB_data_File.write("%12d" % PSUMGB_data[cntBlk][cntPEB][cntPEC][actrow][actcol])  # 32b -> 12d
                                PSUMGB_data_File.write('\n')  # 32b -> 12d
                        # exit()
                AddrBlockAct_all[cntPat][cntBlk + 1 + NumBlk*cntfrm] = AddrBlockAct_tmp #update
            for cntPEB in range(NumPEB):
                for cntPEC in range(NumPEC):
                    for cntwei in range(9):
                        # update next block's addrwei
                        AddrBlockWei_all[cntFtrGrp+1][cntPEB][cntPEC][cntwei] = AddrBlockWei_tmp[cntPEB][cntPEC][cntwei] #reset this ftrgrp's all weights

            # ************* POOL *****************************
            # FRMPOOL, DELTA, cnt_ACT, cnt_Flag, GBFOFM_DatRd, GBFFLGOFM_DatRd = \
            #     POOL.POOL(  PSUMGB_data,fl,POOL_ValIFM,
            #                 FRMPOOL, DELTA, cnt_ACT, cnt_Flag, GBFOFM_DatRd, GBFFLGOFM_DatRd,
            #                 POOL_SPRS_MEMFile, GBFOFM_DatRdFile, POOL_FLAG_MEMFile, GBFFLGOFM_DatRdFile,
            #                 Len, Stride, NumBlk, NumPEB, NumPEC, PORT_DATAWIDTH, cntfrm )
    
