##compute-h2

## Description
Computes heritability for a given set of miRNAs (it could actually be used for other gene products as well).
These are used, e.g., for assessing the quality of prediction models.

The computation is carried out in two steps, starting from genotypes.

#1. Compute GRMs

## Input files

- SNP location file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.bim`). Without header.
> [I]   rsid   [I]   pos   ...

  - `rsid` is rs number of SNP
  - `pos` is the location of the SNP
  - Columns with `[I]` and additional columns at the end are ignored

- GCTA dose file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.mldose.gz`): SNPs dosages, for all chromosomes. Without header.
> ID->ID   MLDOSE   [dosages]

  - `ID` is the sample ID
  - `->` is literal
  - `ID` is the sample ID (again)
  - `MLDOSE` is literal
  - `[dosages]` are dosages for all SNPs

 Sample line:
  > GTEX-P4PP->GTEX-P4PP MLDOSE 1.983 2 2 0.003 0 2 2 2 2 ...

- GCTA info file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.mlinfo.gz`): SNPs info, for all chromosomes. With header line.
> rsid   al1   al2   freq1   MAF   qual   rsq

  - `rsid` is rs number of SNP
  - `al1` is the allele #1
  - `al2` is the allele #2
  - `freq1` is the frequency of allele #1
  - `MAF` is the minor allele frequency, MAF = min(freq1,1-freq1)
  - `qual` is the average posterior probability for the most likely genotype (after imputation)
  - `rsq` estimate the squared correlation between imputed and true genotypes

- GCTA chr dose file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.chr1.mldose.gz`): same as GCTA dose file, for one chromosome.

- GCTA chr info file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.chr1.mlinfo.gz`): same as GCTA info file, for one chromosome.

- Target miRNAs info file (e.g., `...`). Without header.
> chr   [I]   start   end   name  ...

  - `chr` is the chromosome number
  - `start` is the miRNA start location
  - `end` is the miRNA end location
  - `name` is the miRNA name
  - Columns with `[I]` and additional columns at the end are ignored

- Previously processed miRNAs: miRNAs that were already processed, ignore then. Without header. A flag has to be changed in the code to use this feature.
> name
  - `name` is the miRNA name

## Output files

- Set/s of three GRM files (e.g., test.grm.bin, test.grm.N.bin, test.grm.id; two are binary, one is text): One set global, one set per chromosome, one set per miRNA.
See [the GCTA page](http://cnsgenomics.com/software/gcta/estimate_grm.html) for a description.

See also Usage.

## Usage
> Rscript 01_calc_GRMs.r [chr#]

If chromosome number chr# is 0, then three GRM *global* files are created. This has to be done once.
If chr# is between 1 and 22, then three GRM files for the chromosome, plus 3 for each miRNA in that chromosome, are created.

Create submission scripts for queueing with `make_run_scripts_01.py`.

## Useful links

GCTA Input and output: 
http://cnsgenomics.com/software/gcta/input_output.html

GCTA GRM output:
http://cnsgenomics.com/software/gcta/estimate_grm.html

MACH imputation:
http://csg.sph.umich.edu//abecasis/MACH/tour/imputation.html

#2. Compute h2

## Input files

- IDs file (e.g., `DGN-WBexp.ID.list`): List of sample IDs with available expression data. Without header.
> ID

  - `ID` is the sample ID

- miRNAs file (e.g., `DGN-WBexp.GENE.list`): List of miRNAs with available expression data. Without header.
> name

  - `name` is the name of the miRNA

- miRNAs expression file (e.g., `DGN-WB.rntransform.exp.IDxGENE`): List of miRNA expression levels, one line per sample ID. Without header.
> [expression levels]

  - `[expression levels]` is the list of miRNA expression levels for one sample ID.

- Target miRNAs file (e.g., `gencode.v18.genes.patched_contigs.summary.protein.chr22`): List of target miRNAs, for a given chromosome. Without header.
> chr   [I]   [I]   [I]   ensid   name  ...

  - `chr` is the chromosome number
  - `ensid` is the miRNA ENSID
  - `name` is the miRNA name
  - Columns with `[I]` and additional columns at the end are ignored

- Set of 3 GRM files for each gene, see above (`local-<miRNA name>.<grmext>`, with <grmext>=bin, id, N.bin).
  
- Set of 3*22 GRM files for all chromosomes, see above (`DGN.global_Chr<chr#>.<grmext>`).

## Output files

- <cohort>-<tissue>.h2.all.models_<threshold>.Chr<chr#>_globalOtherChr.<date>.txt: One list of miRNAs per chromosome. With headers.
> tissue  N       ensid   gene    local.h2        local.se        local.p gene    global.h2       global.se       global.p        gene    loc.jt.h2       loc.jt.se       glo.jt.h2       glo.jt.se

  - `tissue` is the cohort/tissue
  - `N` no. of samples
  - `ensid` is the ENSID of the miRNA
  - `gene` is the name of the miRNA
  - `local.h2` 
  - `local.se` 
  - `local.p gene` 
  - `global.h2` 
  - `global.se` 
  - `global.p` 
  - `gene` 
  - `loc.jt.h2` 
  - `loc.jt.se` 
  - `glo.jt.h2` 
  - `glo.jt.se` 
  
DGN-WB  922     ENSG00000128274.11      A4GALT  0.784468        0.025632        0       A4GALT  0.262780        0.166041        0.06139 A4GALT  0.783728        0.025741        0.014310        0.044613

## Usage
> 
