import os
import sys
import re
import collections
import subprocess

model = re.compile(r"(?<=Command\{|command\{)\\[a-zA-Z]+")
use = re.compile(r"(?<!Command\{|command\{)\\[a-zA-Z]+")
word = re.compile(r"(?<=Words in text: )\d+")

if (len(sys.argv) > 1):
    path = sys.argv[1]

modelbuf = set()
macrocount = collections.Counter()
totalmacros = 0
totalwords = 0

print("==========================================================================")
print("file                                                          macro   word")
for filename in sys.argv[1:]: 
    with open(filename,'r',encoding="utf-8") as f:
        s = f.read()
        # accumulate new used defined macro
        modelbuf.update(model.findall(s))
        temp = use.findall(s)
        v = len(temp)
        # accumulate macro use counts
        macrocount.update(dict((k,temp.count(k)) for k in temp))
        totalmacros += v
        # get words counts by texcount
        texcount = subprocess.run(["texcount", filename], stdout=subprocess.PIPE)
        temp = word.findall(texcount.stdout.decode("utf-8"))
        w = 0
        if(len(temp) == 1):
            w = int(temp[0])
        totalwords += w
        # print out the total numbers of macros and word counts
        print(f"{filename:60}{v:7}{w:7}")
print("--------------------------------------------------------------------------")
print(f"{totalmacros:67}{totalwords:7}")

# set the counts unused macros as ZERO
macrocount.update(dict((k,0) for k in (modelbuf - set(macrocount.keys()))))

print("==============================")
print("macro                    count")
# print in the desc order of the values by t -> t[1]
for s,v in sorted(macrocount.items(), key=lambda t: t[1], reverse=True):
    print(f"{s:25}{v:5}")

# print("=======================")

# for s in macrocount:
    # print(s)
