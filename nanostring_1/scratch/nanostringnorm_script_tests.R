
# directly import the nCounter output
# path.to.xls.file <- "/home/gus/MEGAsync/zim/main/BCH/Projects/James/Nanostring_pipeline/OKT3/data/OKT3 sample annotation 20160129.xlsx"

require('NanoStringNorm')
path.to.xls.file <- system.file("extdata", "RCC_files", "RCCCollector1_rat_tcdd.xls", package = "NanoStringNorm");
NanoString.mRNA <- read.xls.RCC(x = path.to.xls.file, sheet = 1)
