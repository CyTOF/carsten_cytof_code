


plot_heatmaps_for_sign_expr <- function(){
  
  
  # -----------------------------
  ### Plot one heatmap with base and tx

  ## group the expression by cluster
  if(is.null(adjpval_name2)){
    which_top_pvs <- FALSE
  }else{
    adjpval_name <- adjpval_name2
    pval_name <- pval_name2
    expr_all <- expr_all[order(expr_all$label, expr_all[, pval_name]), , drop = FALSE]
    
    which_top_pvs <- expr_all[, adjpval_name] < 0.05 & !is.na(expr_all[, adjpval_name])
    which(which_top_pvs)
  }
  
  
  if(sum(which_top_pvs) > 0) {
    print("Plot pheatmap2")
    
    expr_heat <- expr_all[which_top_pvs, , drop = FALSE]
    
    # -----------------------------
    ## order the samples by base and tx
    samples2plot <- md[md$response %in% c("NR", "R"), ]
    samples2plot <- samples2plot$shortname[order(samples2plot$day, samples2plot$response)]
    
    ## gap in the heatmap 
    gaps_col <- c(max(grep("base_NR", samples2plot)), rep(max(grep("base", samples2plot)), 2), max(grep("tx_NR", samples2plot)))
    gaps_row <- unique(cumsum(table(expr_heat$label)))
    gaps_row <- gaps_row[gaps_row > 0]
    if(length(gaps_row) == 1) 
      gaps_row <- NULL
    
    ## expression 
    expr <- expr_heat[ , samples2plot, drop = FALSE]
    
    labels_row <- paste0(expr_heat$label, " ", expr_heat$marker, " (", sprintf( "%.02e", expr_heat[, adjpval_name]), ")") 
    labels_col <- colnames(expr)
    
    pheatmap(expr, cellwidth = 28, cellheight = 24, color = colorRampPalette(c("#87CEFA", "#56B4E9", "#0072B2", "#000000", "#D55E00", "#E69F00", "#FFD700"), space = "Lab")(100), breaks = breaks, legend_breaks = legend_breaks, cluster_cols = FALSE, cluster_rows = FALSE, labels_col = labels_col, labels_row = labels_row, gaps_col = gaps_col, gaps_row = gaps_row, fontsize_row = 14, fontsize_col = 14, fontsize = 12, filename = file.path(outdir, paste0(prefix, "expr_", out_name, "_", k, "_pheatmap2", suffix, ".pdf")))
    
    
  }
  
  
  # -----------------------------
  ### Plot heatmaps with R vs NR for base and tx
  
  for(i in levels(md$day)){
    # i = "tx"
    
    adjpval_name <- paste0("adjp_NRvsR_", i)
    pval_name <- paste0("pval_NRvsR_", i)
    
    ## group the expression by cluster
    expr_all <- expr_all[order(expr_all$label, expr_all[, pval_name]), , drop = FALSE]
    
    which_top_pvs <- expr_all[, adjpval_name] < 0.05 & !is.na(expr_all[, adjpval_name])
    which(which_top_pvs)
    
    if(sum(which_top_pvs) > 0){
      print(paste0("Plot pheatmap_", i))
      
      expr_heat <- expr_all[which_top_pvs, , drop = FALSE]
      
      # -----------------------------
      ## order the samples by NR and R
      
      samples2plot <- md[md$response %in% c("NR", "R"), ]
      samples2plot <- samples2plot$shortname[order(samples2plot$response, samples2plot$day)]
      samples2plot <- samples2plot[grep(i, samples2plot)]
      
      ## gap in the heatmap 
      gaps_col <- sum(grepl("_NR", samples2plot))
      gaps_row <- unique(cumsum(table(expr_heat$label)))
      gaps_row <- gaps_row[gaps_row > 0]
      if(length(gaps_row) == 1) 
        gaps_row <- NULL
      
      ## expression
      expr <- expr_heat[ , samples2plot, drop = FALSE]
      
      labels_row <- paste0(expr_heat$label, " ", expr_heat$marker, " (", sprintf( "%.02e", expr_heat[, adjpval_name]), ")") 
      labels_col <- colnames(expr)
      
      pheatmap(expr, cellwidth = 28, cellheight = 24, color = colorRampPalette(c("#87CEFA", "#56B4E9", "#0072B2", "#000000", "#D55E00", "#E69F00", "#FFD700"), space = "Lab")(100), breaks = breaks, legend_breaks = legend_breaks, cluster_cols = FALSE, cluster_rows = FALSE, labels_col = labels_col, labels_row = labels_row, gaps_col = gaps_col, gaps_row = gaps_row, fontsize_row = 14, fontsize_col = 14, fontsize = 12, filename = file.path(outdir, paste0(prefix, "expr_", out_name, "_", k, "_pheatmap_", i, suffix, ".pdf")))
      
      
    }
    
  }
  
  # -----------------------------
  ### Plot one heatmap with R vs NR + heatmap with p-values for NRvsR_base, NRvsR_tx and NRvsR_basevstx
  
  ## group the expression by cluster and order by adjpval
  for(i in length(pval_name_list):1){
    expr_all <- expr_all[order(expr_all[, pval_name_list[i]]), , drop = FALSE]
  }
  
  expr_all <- expr_all[order(expr_all$label), , drop = FALSE]
  
  # which_top_pvs <- rowSums(expr_all[, adjpval_name_list, drop = FALSE] < 0.05, na.rm = TRUE) > 0 & rowSums(is.na(expr_all[, adjpval_name_list, drop = FALSE])) < length(adjpval_name_list)
  which_top_pvs <- rep(TRUE, nrow(expr_all))
  which(which_top_pvs)
  
  if(sum(which_top_pvs) > 0) {
    print("Plot pheatmap3")
    
    expr_heat <- expr_all[which_top_pvs, , drop = FALSE]
    
    # -----------------------------
    ## order the samples by base and tx
    samples2plot <- md[md$response %in% c("NR", "R"), ]
    samples2plot <- samples2plot$shortname[order(samples2plot$day, samples2plot$response)]
    
    ## gap in the heatmap 
    gaps_col <- c(max(grep("base_NR", samples2plot)), rep(max(grep("base", samples2plot)), 2), max(grep("tx_NR", samples2plot)))
    gaps_row <- unique(cumsum(table(expr_heat$label)))
    gaps_row <- gaps_row[gaps_row > 0]
    if(length(gaps_row) == 1) 
      gaps_row <- NULL
    
    ## expression 
    expr <- expr_heat[ , samples2plot, drop = FALSE]
    
    labels_row <- paste0(expr_heat$label, " ", expr_heat$marker) 
    labels_col <- colnames(expr)
    
    pheatmap(expr, cellwidth = 28, cellheight = 24, color = colorRampPalette(c("#87CEFA", "#56B4E9", "#0072B2", "#000000", "#D55E00", "#E69F00", "#FFD700"), space = "Lab")(100), breaks = breaks, legend_breaks = legend_breaks, cluster_cols = FALSE, cluster_rows = FALSE, labels_col = labels_col, labels_row = labels_row, gaps_col = gaps_col, gaps_row = gaps_row, fontsize_row = 14, fontsize_col = 14, fontsize = 12, filename = file.path(outdir, paste0(prefix, "expr_", out_name, "_", k, "_pheatmap3", suffix, ".pdf")))
    
    pvs_heat <- expr_heat[, adjpval_name_list, drop = FALSE]
    
    labels_col <- colnames(pvs_heat)
    gaps_col <- NULL
    
    pheatmap(pvs_heat, cellwidth = 60, cellheight = 24, color = c("grey50", "grey70", "grey90"), breaks = c(0, 0.05, 0.1, 1), legend_breaks = c(0, 0.05, 0.1, 1), legend = FALSE, cluster_cols = FALSE, cluster_rows = FALSE, labels_col = labels_col, labels_row = labels_row, gaps_col = gaps_col, gaps_row = gaps_row, display_numbers = TRUE, number_format = "%.02e", number_color = "black", fontsize_row = 14, fontsize_col = 14, fontsize = 12, filename = file.path(outdir, paste0(prefix, "expr_", out_name, "_", k, "_pheatmap3pvs", suffix, ".pdf")))
    
    
  }
  
  
  
  # ----------------------------------------
  # Plot coefficients NRvsR for base and tx (to show that they correlate)
  # ----------------------------------------
  
  
  # if("adjp_NRvsR_basevstx" %in% colnames(pvs)){
    
  #   adjpval_name <- "adjp_NRvsR_basevstx"
    
  #   ggdf <- coeffs[, c("NRvsR_base", "NRvsR_tx")]
    
  #   limmin <- min(ggdf, na.rm = TRUE)
  #   limmax <- max(ggdf, na.rm = TRUE)
    
  #   ggdf$interaction <- factor(pvs[, adjpval_name] < 0.05, levels = c("FALSE", "TRUE"))
    
  #   ggp <- ggplot(data = ggdf, aes(x = NRvsR_base, y = NRvsR_tx, shape = interaction)) +
  #     geom_point(size = 3, alpha = 0.75) +
  #     geom_abline(intercept = 0, slope = 1) +
  #     coord_cartesian(xlim = c(limmin, limmax), ylim = c(limmin, limmax)) +
  #     theme_bw() +
  #     theme(axis.text = element_text(size=14), 
  #       axis.title = element_text(size=14, face="bold"))
    
  #   pdf(file.path(outdir, paste0(prefix, "expr_", out_name, "_", k, "_coeffs", suffix, ".pdf")), w=6, h=5, onefile=TRUE)
  #   print(ggp)
  #   dev.off()
    
    
  # }
  
  
  
  
  return(NULL)
  
}


