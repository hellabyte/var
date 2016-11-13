from hellaPy import *
from pylab import *
from numpy import *
from ast import literal_eval as lvl

with open('dat/cpus.txt','r') as f:
  q= lvl(f.read())
C,R = [],ones(len(q))
for k,cpu in enumerate(q): 
  w = q[cpu]
  s,c = w['score'], w['cost']
  r = s/c
  print( cpu, w, r )
  C.append(cpu)
  R[k] = r
    
Rq = argsort(R)
Cq = [ C[k] for k in Rq ]

figure(1,figsize=(16,6)); clf()
plot(R[Rq],'ko-',ms=9,mfc='w',mec='r',clip_on=False)
xticks(range(len(Cq)),Cq,rotation=90)
tick_params(axis='x',which='minor',bottom='off',top='off')
xlim(0,len(Cq)-1)
ylabel(r'(GBps/\$)')
title(r'DGEMM Throughput over cost')
savefig('fig/cpus.pdf')
