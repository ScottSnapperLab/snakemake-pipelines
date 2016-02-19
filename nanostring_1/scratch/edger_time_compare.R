library('edgeR')

# read in nanostringnorm-normalized data
x <- read.delim("/home/gus/MEGAsync/zim/main/BCH/Projects/James/Nanostring_pipeline/OKT3/OKT3_pipeline_output/NanoStringNorm/data.norm.csv", sep = ',',row.names = 1)
x <- x[,order(colnames(x))]

# read in target annotations for the design matrix stuff later
targets <- read.table("/home/gus/MEGAsync/zim/main/BCH/Projects/James/Nanostring_pipeline/OKT3/OKT3_pipeline_output/OKT3_annotation_for_edger.csv",sep = ',', header = TRUE, row.names = 1)
targets <- targets[order(rownames(targets)),]
targets.rownames <- rownames(targets)
targets <- data.frame(lapply(targets,factor))
row.names(targets) <- targets.rownames

combo <- factor(paste(targets$Sample_Type,targets$Week,sep="."))
targets <- cbind(targets,Combo=combo)

# create the DEGList object
group <- factor(targets$Combo)
y <- DGEList(counts=x,group=group)


# Generate design matrix
design <- model.matrix(~0+Combo, data=targets)


# Estimate dispersion and plot useful figures
y <- estimateDisp(y, design)

plotBCV(y)
plotMDS(y)


fit <- glmFit(y, design)

# Generate contrasts
contr <- makeContrasts(ComboCD14.0-ComboCD14.5, levels=design)


# Do likelihood ratio tests
lrt.contr <- glmLRT(fit, contrast=contr)

topTags(lrt.contr)
