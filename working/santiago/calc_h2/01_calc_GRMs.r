####by Heather E. Wheeler 20141114####
args <- commandArgs(trailingOnly=T)
"%&%" = function(a,b) paste(a,b,sep="")
date = Sys.Date()

### hapmap2 non-ambiguous SNPs were extracted from the GTEx genotype data on genegate with:
### /nas40t2/hwheeler/PrediXcan_CV/GTEx_2014-06013_release/1_vcf2dosage.mach_gtex_hapmapSNPs.pl
### and scp'd to tarbell: /group/im-lab/hwheeler/cross-tissue/gtex-genotypes/

###Takes one argument for the chromosome number. Enter 0 to make globalGRM once.

##ToDo:
###Fully replace directories


my.dir <- "/group/im-lab/nas40t2/hwheeler/cross-tissue/"
rna.dir <- my.dir %&% "gtex-rnaseq/"
annot.dir <- my.dir %&% "gtex-annot/"
gt.dir <- my.dir %&% "gtex-genotypes/"
grm.dir <- my.dir %&% "gtex-grms/"

my2.dir <- "/group/im-lab/nas40t2/santiago/data/gtex/"
grm2.dir <- my2.dir %&% "gtex-grms/"

gencodeset <- args[1]

###make globalGRM, only need to do once

machpre <- gt.dir %&% "GTEx_Analysis_2014-06-13.hapmapSnpsCEU" 
make_global <- FALSE
if ( gencodeset == 0 ) {
#    make_global <- TRUE
#}
#if ( make_global ) {
    cat( "Make only global GRMs\n" )
    GCTAdosefile <- machpre %&% ".mldose.gz"
    GCTAinfofile <- machpre %&% ".mlinfo.gz"
    GTExbase <- grm2.dir %&% "GTEx.global"
    runGCTAglo <- "gcta64 --dosage-mach-gz " %&% GCTAdosefile %&% " " %&% GCTAinfofile %&% " --make-grm-bin --out " %&% GTExbase
    #runGCTAglo <- "gcta64 --dosage-mach-gz " %&% gt.dir %&% machpre %&% "mldose.gz " %&% gt.dir %&% machpre %&% "mlinfo.gz --make-grm-bin --out " %&% grm2.dir %&% "GTEx.global"
    system(runGCTAglo)
    quit()
}

##make chrGRM

machprechr <- machpre %&% ".chr" %&% gencodeset
GCTAchrdosefile <- machprechr %&% ".mldose.gz"
GCTAchrinfofile <- machprechr %&% ".mlinfo.gz"
GTExchrbase <- grm2.dir %&% "GTEx.chr" %&% gencodeset
runGCTAchr <- "gcta64 --dosage-mach-gz " %&% GCTAchrdosefile %&% " " %&% GCTAchrinfofile %&% " --make-grm-bin --out " %&% GTExchrbase
#runGCTAchr <- "gcta64 --dosage-mach-gz " %&% gt.dir %&% machpre %&% "chr" %&% gencodeset %&%  ".mldose.gz " %&% gt.dir %&% machpre %&% "chr" %&% gencodeset %&% ".mlinfo.gz --make-grm-bin  --out " %&% grm.dir %&% "GTEx.chr" %&% gencodeset
system(runGCTAchr)

###make localGRMs, for subset of genes in gencodeset

bimfile <- gt.dir %&% "GTEx_Analysis_2014-06-13.hapmapSnpsCEU.bim" ###get SNP position information###
bim <- read.table(bimfile)
rownames(bim) <- bim$V2

gencodefile <- annot.dir %&% "gencode.v18.genes.patched_contigs.summary.protein.chr" %&% args[1]
gencode <- read.table(gencodefile)
rownames(gencode) <- gencode[,5]

#read_prev <- TRUE
read_prev <- FALSE
if (read_prev) {
    prevgrmsfile <- my.dir %&% "done.grms"
    #prevgrmsfile <- "done.grms"
    finished.grms <- scan(prevgrmsfile,"character") ###already calculated a bunch of grms using old script with whole genome mach files, don't run them again
    ensidlist <- setdiff(rownames(gencode),finished.grms)
} else {
    #ensidlist <- gencode[,5]
    ensidlist <- rownames(gencode)
}

for(i in 1:length(ensidlist)){
    cat(i,"/",length(ensidlist),"\n")
    gene <- ensidlist[i]
    geneinfo <- gencode[gene,]
    chr <- geneinfo[1]
    c <- substr(chr$V1,4,5)
    start <- geneinfo$V3 - 1e6 ### 1Mb lower bound for cis-eQTLS
    end <- geneinfo$V4 + 1e6 ### 1Mb upper bound for cis-eQTLs
    chrsnps <- subset(bim,bim[,1]==c) ### pull snps on same chr
    cissnps <- subset(chrsnps,chrsnps[,4]>=start & chrsnps[,4]<=end) ### pull cis-SNP info
    snplist <- cissnps[,2]
    SNPtmpfile <- my2.dir %&% "tmp.SNPlist." %&% gencodeset
    write.table(snplist,file=SNPtmpfile,quote=F,col.names=F,row.names=F)
    #write.table(snplist, file= my2.dir %&% "tmp.SNPlist." %&% gencodeset,quote=F,col.names=F,row.names=F)
    grmlocalbase <- grm2.dir %&% gene
    runGCTAgrm <- "gcta64 --dosage-mach-gz " %&% GCTAchrdosefile %&% " " %&% GCTAchrinfofile %&% " --make-grm-bin --extract " %&% SNPtmpfile %&% " --out " %&% grmlocalbase
    #runGCTAgrm <- "gcta64 --dosage-mach-gz " %&% gt.dir %&% machpre %&% "chr" %&% gencodeset %&%  ".mldose.gz " %&% gt.dir %&% machpre %&% "chr" %&% gencodeset %&% ".mlinfo.gz --make-grm-bin --extract " %&% my2.dir %&% " tmp.SNPlist." %&% gencodeset %&% " --out " %&% grm2.dir %&% gene
    system(runGCTAgrm)
}
