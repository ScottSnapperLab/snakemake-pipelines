library('edgeR')

# read in nanostringnorm-normalized data
x <- read.delim("/home/gus/MEGAsync/zim/main/BCH/Projects/James/Nanostring_pipeline/OKT3/OKT3_pipeline_output/NanoStringNorm/data.norm.csv", sep = ',',row.names = 1)
x <- x[,order(colnames(x))]

# read in target annotations for the design matrix stuff later
targets <- read.table("/home/gus/MEGAsync/zim/main/BCH/Projects/James/Nanostring_pipeline/OKT3/OKT3_pipeline_output/OKT3_annotation_for_edger.csv",sep = ',', header = TRUE, row.names = 1)
targets <- targets[order(rownames(targets)),]
targets <- lapply(targets,factor)

# create the DEGList object
group <- factor(targets$Sample_Type)
y <- DGEList(counts=x,group=group)


# Generate design matrix
design <- model.matrix(~0+group, data=y$samples)
colnames(design) <- levels(y$samples$group)

# Estimate dispersion and Fit the model
y <- estimateDisp(y, design)
fit <- glmFit(y, design)

# Generate contrasts
CD14.v.Tcon <- makeContrasts(CD14-Tcon, levels=design)


# Do likelihood ratio tests
lrt.CD14.v.Tcon <- glmLRT(fit, contrast=CD14.v.Tcon)

topTags(lrt.CD14.v.Tcon)
