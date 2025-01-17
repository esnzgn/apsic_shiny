rm(list=ls())
library(ggplot2)
library(reshape2)
library(viridis)
source("../apsic_shiny/common.r")
source("../apsic_shiny/waterfall_plot_methods.r")
source("scripts/plot_functions_for_profiles.r")

# load viability data
load("../apsic_shiny/cancerData.RData")

set.seed(1397)

fig_folder = "figures/fig1/"
dir.create(fig_folder, recursive = T, showWarnings = FALSE)

gene = "TP53"

############## Figure 1-a
pdf(paste0(fig_folder, "fig-1-a.pdf"), 8, 6) 
waterfallForGene(cancerData, gene = gene, title="", rank=FALSE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)
dev.off()

# png(paste0(fig_folder,"fig-1-a.png", res = 300))
# par(bg=NA)
# waterfallForGene(cancerData, gene = gene, title="", rank=FALSE, legenedPos="bottomleft", 
#                  cols=NULL, type="all", sig_alpha = NA)
# dev.off()


############## Figure 1-b
pdf(paste0(fig_folder,"fig-1-b.pdf"), 8, 6)
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)
dev.off()

############## Figure 1-c
pdf(paste0(fig_folder,"fig-1-c.pdf"), 8, 6)
gene =3000
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)
dev.off()

############## Figure 1-d  -- KRAS
pdf(paste0(fig_folder,"fig-1-d_wt_kras.pdf"), 10, 6)
gene = "KRAS"
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="only_wt", sig_alpha = NA)

dev.off()

pdf(paste0(fig_folder, "fig-1-d_missense_kras.pdf"), 8, 6)
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="only_missense", sig_alpha = NA)
dev.off()



############## Figure 1-d  -- TP53
pdf(paste0(fig_folder,"fig-1-d_wt_tp53.pdf"), 5, 4)
gene = "TP53"
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="only_wt", sig_alpha = NA)

dev.off()

pdf(paste0(fig_folder,"fig-1-d_missense_tp53.pdf"), 5, 4)
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="only_missense", sig_alpha = NA)
dev.off()


selectedData = selectCelllines(cancerData, "Breast:Carcinoma", tableS2File="../apsic_shiny/TableS2.csv")
gene = "NR3C2"
pdf(paste0(fig_folder,"fig-1-e-non-genetic-wt.pdf"), 5, 4)
waterfallForGene(selectedData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="only_wt", sig_alpha = NA)
dev.off()

pdf(paste0(fig_folder,"fig-1-e-non-genetic-tcga.pdf"), 5, 4)
load("../apsic_shiny/tcga/TCGA-BRCA.RData")
boxplot_gene(tcga_data, "PARP4")
dev.off()

# plot mutation profile
pdf(paste0(fig_folder,"fig-1-mut-profile.pdf"), 10, 6)
indexes = tail(order(apply(selectedData$mutations_all, 1, sum)), n=40)
plotDriverGenes(selectedData$mutations_all[indexes, 1:20]) 
dev.off()



# plot perturbation profile
n = nrow(selectedData$viabilities)
perturbData = as.matrix(selectedData$viabilities[sample(n, 40), ])

pdf(paste0(fig_folder,"fig-1-perturb-profile.pdf"), 10, 6)
plotPerturbationProfile(perturbData)
dev.off()



selectCelllinesWithIndexes <- function(panCancerData, indexes) {
  panCancerData$viabilities = panCancerData$viabilities[, indexes, drop=FALSE]
  panCancerData$mutations_all = panCancerData$mutations_all[, indexes, drop=FALSE]
  panCancerData$silentMutations = panCancerData$silentMutations[, indexes, drop=FALSE]
  panCancerData$missenseMutations = panCancerData$missenseMutations[, indexes, drop=FALSE]
  panCancerData$truncatingMutations = panCancerData$truncatingMutations[, indexes, drop=FALSE]
  
  panCancerData$copyNumbers = panCancerData$copyNumbers[, indexes, drop=FALSE]
  # panCancerData$exprData = panCancerData$exprData[, indexes]
  panCancerData
}

gene = "KRAS"
indexes = which(cancerData$truncatingMutations[gene, ] ==0)
subCancerData = selectCelllinesWithIndexes(cancerData, indexes) 

pdf(paste0(fig_folder, "fig-1-kras_missense_wt.pdf"), 8, 6)
waterfallForGene(subCancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)
dev.off()


selectedData = selectCelllines(cancerData, "Breast:Carcinoma", tableS2File="../apsic_shiny/TableS2.csv")
gene = "LRRC4B"
pdf(paste0(fig_folder,"fig-1-lrrc4b.pdf"), 10, 6)
waterfallForGene(selectedData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)
dev.off()



############## Figure 2-b  -- BRAF
pdf(paste0(fig_folder,"fig-2-braf.pdf"), 10, 6)
gene = "BRAF"
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)

dev.off()



############## Figure 2-c  -- KRAS
pdf(paste0(fig_folder,"fig-2-kras.pdf"), 10, 6)
gene = "KRAS"
waterfallForGene_CNA(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)

dev.off()



############## Figure 2-d  -- ARID1A
pdf(paste0(fig_folder,"fig-2-arid1a.pdf"), 10, 6)
gene = "ARID1A"
waterfallForGene(cancerData, gene = gene, title="", rank=TRUE, legenedPos="bottomleft", 
                 cols=NULL, type="all", sig_alpha = NA)

dev.off()