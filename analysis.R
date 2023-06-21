\# analysis.R

 

\# Load libraries and read data

library(ballgown)

library(RSkittleBrewer)

library(genefilter)

library(dplyr)

library(devtools)

pheno_data <- read.csv("/chrX_data/geuvadis_phenodata.csv")

 

\# Create ballgown object

bg_chrX <- ballgown(dataDir = "/ballgown", samplePattern = "ERR", pData = pheno_data)

bg_chrX_filt = subset(bg_chrX, "rowVars(texpr(bg_chrX)) >1",genomesubset=TRUE)

 

\# Perform statistical analysis and get results

results_transcripts <- stattest(bg_chrX_filt, feature = "transcript", covariate = "sex", adjustvars = c("population"), getFC = TRUE, meas = "FPKM")

results_genes <- stattest(bg_chrX_filt, feature = "gene", covariate = "sex", adjustvars = c("population"), getFC = TRUE, meas = "FPKM")

results_transcripts <- data.frame(geneNames = ballgown::geneNames(bg_chrX_filt), geneIDs = ballgown::geneIDs(bg_chrX_filt), results_transcripts)

 

\# Save results to CSV files

write.csv(results_transcripts, "chrX_transcript_results.csv", row.names = FALSE)

write.csv(results_genes, "chrX_gene_results.csv", row.names = FALSE)

 

\# Visualization code

tropical <- c("darkorange", "dodgerblue", "hotpink", "limegreen", "yellow")

palette(tropical)

fpkm <- texpr(bg_chrX, meas = "FPKM")

fpkm <- log2(fpkm + 1)

boxplot(fpkm, col = as.numeric(pheno_data$sex), las = 2, ylab = "log2(FPKM+1)")

 

\# Visualize individual gene and transcript

ballgown::transcriptNames(bg_chrX)[12] ## 12 ## "NM_012227"

ballgown::geneNames(bg_chrX)[12] ## 12 ## "GTPBP6"

plot(fpkm[12,] ~ pheno_data$sex, border = c(1, 2), main = paste(ballgown::geneNames(bg_chrX)[12], ": ", ballgown::transcriptNames(bg_chrX)[12]), pch = 19, xlab = "Sex", ylab = "log2(FPKM+1)")

points(fpkm[12,] ~ jitter(as.numeric(pheno_data$sex)), col = as.numeric(pheno_data$sex))

 

\# Additional visualization steps

plotTranscripts(ballgown::geneIDs(bg_chrX)[1729], bg_chrX, main = c("Gene XIST in sample ERR188234"), sample = c("ERR188234"))

plotMeans("MSTRG.56", bg_chrX_filt, groupvar = "sex", legend = FALSE)

 

\# Save the updated script as analysis.R