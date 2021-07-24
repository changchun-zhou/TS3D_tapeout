import os
def alter(file):
    with open(file, "r") as f1,open("%s.RSB" % file, "w") as f2:
        flag_modSM = 0
        flag_modf_SB = 0
        for line in f1:
            if "module PEB_151897 " in line or "module PEB_151896 " in line or\
               "module PEB_151895 " in line or "module PEB_151894 " in line : # 4 PEB
                    flag_modSM = 1
            if "endmodule" in line:
                flag_modSM = 0

            if flag_modSM == 1:
                if "datain_val_reg" in line or "IDMAC_push_reg" in line or\
                    "MACPSUM_empty_reg" in line or "datain_reg" in line:
                        line = line.replace("DFQRM", "DFQSM")
                        flag_modf_SB = 1
                if flag_modf_SB == 1:
                    if ".RB(" in line:
                        line = line.replace(".RB(", ".SB(")
                        flag_modf_SB = 0
                if "));" in line:
                    flag_modf_SB = 0
                f2.write(line)
    # os.remove(file)
    # os.rename("%s.bak" % file, file)

alter("eco.v")