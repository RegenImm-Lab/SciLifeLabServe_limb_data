
######################################################################
# 001: Loading Necessary Packages
######################################################################

library(Seurat)
library(ShinyCell2)
library(shiny)

######################################################################
# 002: Preparing Seurat Objects From Merged and Immune Dataset
######################################################################

# read in the first Seurat object 
merged <- readRDS("../01_PreProcessing/20260421.merged.edit.rds")

# create the shinycell config
Conf_merged <- createConfig(merged)

# removing unecessary metadata 
Conf_merged <- delMeta(Conf_merged, c("orig.ident", "unintegrated_clusters", "seurat_clusters",
 "cca_clusters", "RNA_snn_res.0.5"))

# changing metadata display names

# Conf_merged <- modMetaName(Conf_merged, 
#                      meta.to.mod = c("", ""), 
#                      new.name = c("", ""))


print("Merged config created.")

######################################################################

# read in the second Seurat object 
immune <- readRDS("../01_PreProcessing/20260421.immune_filtered.edit.rds")

# create the shinycell config
Conf_immune <- createConfig(immune)

# removing unecessary metadata 
Conf_immune <- delMeta(Conf_immune, c("orig.ident", "unintegrated_clusters", "seurat_clusters",
 "cca_clusters", "RNA_snn_res.0.5", "RNA_snn_res.0.75", "cytetype_annos", "cond_rep"))

# changing metadata display names
# Conf_immune <- modMetaName(Conf_immune, 
#                      meta.to.mod = c("", ""), 
#                      new.name = c("", ""))

print("Immune config created.")


######################################################################
# 003: Setting Up Directory to Store ShinyCell Files
######################################################################

# make a new directory that will store any generated files
shiny_dir <- "../03_App"
dir.create(shiny_dir, showWarnings = FALSE, recursive = TRUE)  # make the dir if it doesn't already exist

print("ShinyApp files will be stored in 03_App/")

######################################################################
# 004: Creating Shiny Files
######################################################################

## the descriptors under each tab are included in the UI file

makeShinyFiles(merged, Conf_merged,
  gex.assay = "RNA",  # Assay(merged) --> RNA
  dimred.to.use = "umap.cca",  # only display umap reduction
  shiny.prefix = "merged_obj", 
  shiny.dir = shiny_dir,
  default.gene1 = "VWF", 
  default.gene2 = "PTPRC",
  default.gene3 = "MDK",
  default.gene4 = "LYZ",
  default.gene5 = "CSF1R",
  default.gene6 = "POSTN",
  default.gene7 = "CAV1",
  default.multigene = c("MDK", "LYZ", "CSF1R", "CAV1", "CD79A", "VWF", "POSTN", "PTPRC", "RARRES1", "DPT", "COL4A1", "PFN2")
)

print("Shiny files created for merged dataset.")


makeShinyFiles(immune, Conf_immune, 
  gex.assay = "RNA",   # Assay(immune) --> RNA
  dimred.to.use = "umap_immune", # only display umap reduction
  shiny.prefix = "immune_obj", 
  shiny.dir = shiny_dir,
  default.gene1 = "JCHAIN", 
  default.gene2 = "CD3E",
  default.gene3 = "CD79A",
  default.gene4 = "CSF1R",
  default.gene5 = "APOE",
  default.gene6 = "PLBD1",
  default.gene7 = "MMP9",
  default.multigene = c("CD79A", "CD3E", "JCHAIN", "CSF1R", "APOE", "PLBD1", "LAPTM5", "CSF1R", "C1QB", "CTSL", "MMP9", "IGLL1", "TCF7")
) 

print("Shiny files created for immune dataset.")


######################################################################
# 004: Editing Shiny Files
######################################################################

# merged: rename dimrd label in def file
merged_objdef <- readRDS("../03_App/merged_objdef.rds")
merged_objdef$dimrd <- gsub("umap.cca", "UMAP", merged_objdef$dimrd)
saveRDS(merged_objdef, "../03_App/merged_objdef.rds")

# merged: rename key in dimr file to match
merged_objdimr <- readRDS("../03_App/merged_objdimr.rds")
names(merged_objdimr)[names(merged_objdimr) == "umap.cca"] <- "UMAP"
saveRDS(merged_objdimr, "../03_App/merged_objdimr.rds")

# immune: rename dimrd label in def file
immune_objdef <- readRDS("../03_App/immune_objdef.rds")
immune_objdef$dimrd <- gsub("umap_immune", "UMAP", immune_objdef$dimrd)
saveRDS(immune_objdef, "../03_App/immune_objdef.rds")

# immune: rename key in dimr file to match
immune_objdimr <- readRDS("../03_App/immune_objdimr.rds")
names(immune_objdimr)[names(immune_objdimr) == "umap_immune"] <- "UMAP"
saveRDS(immune_objdimr, "../03_App/immune_objdimr.rds")



######################################################################
# 005: Creating ShinyApp
######################################################################

makeShinyCodes(
  shiny.title = "Single-Cell RNA-seq Time Course of Axolotl Limb Regeneration", 
  shiny.footnotes = "Data source: Leigh et al. (2018) Transcriptomic landscape of the blastema niche in regenerating adult axolotl limbs at single-cell resolution. Nature Communications. https://doi.org/10.1038/s41467-018-07604-0 | Shiny app developed with ShinyCell2.", 
  shiny.prefix = c("merged_obj", "immune_obj"),
  shiny.headers = c("All Cells", "Immune Cells"),
  shiny.dir = shiny_dir)

print("ShinyApp built.")

######################################################################
# 006: Creating app.R script for app running.
######################################################################

app_r_content <- '######################################################################
# 001: Loading Necessary Packages
######################################################################

library(shiny)
library(shinyhelper)
library(DT)
library(data.table)
library(ggdendro)
library(ggpubr)
library(Matrix)
library(magrittr)
library(ggplot2)
library(ggrepel)
library(hdf5r)
library(gridExtra)

######################################################################
# 002: Loading in UI and Server Scripts
######################################################################

source("ui.R") 
source("server.R")

# launch the app
shiny::runApp(".", launch.browser = TRUE)
'
writeLines(app_r_content, file.path(shiny_dir, "app.R"))

