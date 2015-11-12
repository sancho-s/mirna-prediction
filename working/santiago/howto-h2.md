
##Steps to perform heritability (h2) calculation

###1. Compute GRMs

####Script:
04_calc_GRMs.r

####Inputs:
bimfile (no header). Sample line:
```
1       rs10399749      0       55299   T       C
```

GCTAdosefile (no header). Sample line:
```
GTEX-P4PP->GTEX-P4PP MLDOSE 1.983 2 2 0.003 0 2 2 2 2 ...
```

GCTAinfofile (with header, for all chromosomes). Sample lines:
```
SNP     Al1   Al2  Freq1     MAF    Quality Rsq
rs10399749    T C  0.171     0.171  0.792  0.409
```

GCTAchrdosefile (as GCTAdosefile, one per chromosome)

GCTAchrinfofile (as GCTAinfofile, one per chromosome)

gencodefile
```
```

prevgrmsfile (optional)
```
```

####Outputs:

Create submission scripts with make_run_scripts_04.py.

###2. Compute h2

Script:

Inputs:

Outputs:

