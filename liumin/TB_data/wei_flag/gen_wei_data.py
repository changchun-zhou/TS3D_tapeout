# -*- coding: utf-8 -*-
# @Author: MinLiu
# @Date:   2020-08-07 17:10:08
# @Last Modified by:   刘敏
# @Last Modified time: 2020-08-07 18:30:21

import linecache
import os
import random

SRAM_SIZE  = 8 * 1024  * 8
PORT_WIDTH = 128
SRAM_DEPTH = int(SRAM_SIZE / PORT_WIDTH)
BIT_WIDTH  = 8
WORD_NUM   = int(SRAM_SIZE / BIT_WIDTH)

file_flag = linecache.getlines("wei_flag_SRAM_Block_0.txt")
if (os.path.exists("wei_data_SRAM_Block.txt")):
    os.remove("wei_data_SRAM_Block.txt")

if (os.path.exists("wei_addr_SRAM_Block.txt")):
    os.remove("wei_addr_SRAM_Block.txt")

data_cnt_nz    = 0
data_cnt_iz    = 0
block_cnt_iz   = 0
line_cnt       = 0
total_data_num = 32 * 27 * 32
cnt            = 0

wei_addr = 0
for line in file_flag:
    line = list(line)
    line.remove("\n")
    nz_cnt = 0
    line_cnt = 0
    for flag in line:
        data = ''
        if (flag == '1'):
            nz_cnt = nz_cnt + 1
            for bit in range(0, BIT_WIDTH):
                data = data + str(random.randint(0, 1))
            one_bit       = random.randint(0, BIT_WIDTH - 1)
            data          = list(data)
            data[one_bit] = '1'
            data          = ''.join(data)
            data_cnt_iz = data_cnt_iz + 1

            with open("wei_data_SRAM_Block.txt", "a") as file_data:
                if (line_cnt == int(PORT_WIDTH / BIT_WIDTH) - 1):
                    line_cnt = 0
                    file_data.write(data)
                    file_data.write('\n')
                else:
                    line_cnt = line_cnt + 1
                    file_data.write(data)

            if (data_cnt_iz == total_data_num):
                break
            elif(data_cnt_nz == WORD_NUM - 1):
                data_cnt_nz    = 0
            else:
                data_cnt_nz    = data_cnt_nz + 1
        else:
            data_cnt_iz = data_cnt_iz + 1
            pass

        if (data_cnt_iz == total_data_num):
            break
    if (nz_cnt % 16 != 0):
        with open("wei_data_SRAM_Block.txt", "a") as file_data:
            # print(16 - nz_cnt % 16)
            for i in range(0, 16 - nz_cnt % 16):
                for bit_ in range(0, 8):
                    file_data.write("0")
            file_data.write("\n")

    with open("wei_addr_SRAM_Block.txt", "a") as file_addr:
        if (cnt == 7):
            cnt = 0
            for zero_add in range(0, 16 - len(str(bin(wei_addr))[2:])):
                file_addr.write("0")
            file_addr.write(str(bin(wei_addr))[2:])
            file_addr.write("\n")
        else:
            cnt = cnt + 1
            for zero_add in range(0, 16 - len(str(bin(wei_addr))[2:])):
                file_addr.write("0")
            file_addr.write(str(bin(wei_addr))[2:])
        wei_addr = wei_addr + int(nz_cnt / 16)

    if (data_cnt_iz == total_data_num):
        break
