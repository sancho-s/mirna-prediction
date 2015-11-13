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
  - `freq1` is the frequency of allele #?
  - `MAF` is the minor allele frequency, MAF = min(freq1,1-freq1)
  - `qual` is the quality of ...
  - `rsq` is the correlation coefficient of ...

- GCTA chr dose file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.chr1.mldose.gz`): same as GCTA dose file, for one chromosome.

- GCTA chr info file (e.g., `GTEx_Analysis_2014-06-13.hapmapSnpsCEU.chr1.mlinfo.gz`): same as GCTA info file, for one chromosome.

- miRNA info file (e.g., `...`). Without header.
> chr   [I]   start   end   name  ...

  - `chr` is the chromosome number
  - `start` is the miRNA start location
  - `end` is the miRNA end location
  - `name` is the miRNA name
  - Columns with `[I]` and additional columns at the end are ignored

- Previously processed miRNAs: miRNA that were already processed, ignore then. Without header. A flag has to be changed in the code to use this feature.
> name
  - `name` is the miRNA name


## Output files

Set/s of three GRM global files, see Usage.

## Usage
> Rscript 04_calc_GRMs.r <chr#>

If chr# is 0, then three GRM global files are created.
If chr# is between 1 and 22, then three GRM files for the chromosome, plus 3 for each miRNA in that chromosome, are created.

Create submission scripts for queueing with `make_run_scripts_04.py`.


#2. Compute h2

## Input files

## Output files

## Usage
> 
