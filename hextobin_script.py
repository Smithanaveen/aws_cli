import math
import sys

def converttobin(res, numofzero):
    x = res
    if len(res) < 16:        
        for i in range(numofzero):
            x = '0' + x
    return(x)


tempstring = str(sys.argv[1])
ini_string1 = tempstring[0:len(tempstring)//2]
ini_string2 = tempstring[len(tempstring)//2:]                        

res1 = "{0:08b}".format(int(ini_string1, 16))
res2 = "{0:08b}".format(int(ini_string2, 16))
print ("Resultant unpadded binary is", str(res1), "and", str(res2))

numofzero1 = (16 - len(res1))
numofzero2 = (16 - len(res2))

padded1 = converttobin(res1, numofzero1)
padded2 = converttobin(res2, numofzero2)

dword = padded1 + padded2
print ("padded binary string is ", str(dword))

tasktag=dword[24:]
lun=dword[16:24]
flags=dword[8:16]
txcode=dword[:8]
txcode1=txcode[:4]
txcode2=txcode[4:8]

print("###### start of output #######")
print("tasktag is: ", tasktag)
print("####################")
print("lun is: ", lun)
print("####################")
print("flags is: ", flags)
print("####################")
print("txcode1 is: ", txcode1)
print("####################")
print("txcode2 is: ", txcode2)
