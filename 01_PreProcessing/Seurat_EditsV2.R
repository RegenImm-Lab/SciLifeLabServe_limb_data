######################################################################
# 001: Loading Necessary Packages
######################################################################

library(Seurat)

######################################################################
# 002: Editing Merged and Immune Datasets
######################################################################

merged <- readRDS("20251212.merged_copy.rds") # this is the original object sent to me

merged$timepoint <- merged$group  # copies group to timepoint
merged$group <- NULL # deletes original group col

merged@reductions$umap.cca@key <- "UMAP_" # rename the umap reduction (for clean UI in the app) (only renames the key)
colnames(merged@reductions$umap.cca@cell.embeddings) <- c("UMAP_1", "UMAP_2") # also changing the column names

######################################################################

immune <- readRDS("20251212.immune_filtered_copy.rds") # original immune object

immune$timepoint <- immune$group # copy group to timepoint
immune$group <- NULL # delete og group column

immune@reductions$umap_immune@key <- "UMAP_" # same for immune UMAP (only renames the key)
colnames(immune@reductions$umap_immune@cell.embeddings) <- c("UMAP_1", "UMAP_2")


######################################################################
# 003: Saving
######################################################################

saveRDS(merged, "20260325.merged.edit.rds") # save to new edited objects

saveRDS(immune, "20260325.immune_filtered.edit.rds")