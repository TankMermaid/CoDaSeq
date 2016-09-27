draw.grey.boxes <- function(at) {
   xlim <- par('usr')[1:2] # gets the limit of the bounding box
   for ( a in 1:length(at) ) {
       if ( a %% 2 == 1 ) next
       rect( xlim[1], a - 0.5, xlim[2], a + 0.5, border=NA, col=rgb(0,0,0,0.1) )
   }

}

codaSeq.stripchart <- function(
    aldex.out=NULL, group.table=NULL, group.label=NULL, p.method="wi.eBH",
    x.axis="effect", effect.cutoff=1, p.cutoff=0, cex=0.8,
    main=NULL, mar=c(2,12,4,0.5), do.ylab=TRUE)
  {
  # aldex.out is the data frame of observations to be plotted
  # group.table taxon information. Each column is a taxon name at a specific level
  # group.label is the column name from the taxon file
  # x.axis should be either diff.btw (difference) or effect
  # cex controls plot size
  # p.cutoff is the BH corrected wilcoxon rank test statistic
  # effect.cutoff is the BH corrected wilcoxon rank test statistic
  # do.ylab controls whether to add y axis label to plot for pseudo-time series display
  # copy the aldex output data frame

  if(is.null(aldex.out)) stop("please supply an appropriate input from ALDEx2")
  if(is.null(group.table)) stop("please supply an appropriate group table")
  if(is.null(group.label)) stop("please supply an appropriate group label")
  if(p.cutoff > 0.1) stop("p value cutoff not realistic")

  aldex.out <- data.frame(aldex.out, group.table[rownames(aldex.out), group.label])
  colnames(aldex.out)[ncol(aldex.out)] <- group.label
  aldex.out <- droplevels(aldex.out)

  # get a vector of significant and non-significant rows
  non.sig <- abs(aldex.out$effect) < effect.cutoff & aldex.out[,p.method] > p.cutoff
  sig.pos <- aldex.out$effect >= effect.cutoff
  sig.neg <- aldex.out$effect <= effect.cutoff * -1

  # get a vector of significant and non-significant rows
  p.sig <- aldex.out[,p.method] < p.cutoff & abs(aldex.out$effect) < effect.cutoff

  # make a list of unique groups in the dataset
  # there may be empty groups.set, ignore these for now
  groups.set <- unique(aldex.out[[group.label]])

  # generate a y axis plotting limit a bit larger than needed
  ylim<-c(length(groups.set) - (length(groups.set)+0.5), length(groups.set) + 0.5)

  x.axis <- x.axis # we find the effect or diff.btw columns to be most useful
  xlim = c(min(-1 * max(abs(aldex.out[,x.axis]))), max(aldex.out[,x.axis]))

  # basically can call the different significant groups.set within strip chart
  par(mar=mar, las=1, cex=cex)
if(do.ylab == TRUE) { stripchart(aldex.out[non.sig,x.axis] ~ aldex.out[non.sig,group.label],
    col=c(rgb(0,0,0,0.3),rgb(0,0,0,0.3)), method="jitter", pch=19, xlim=xlim, xlab=x.axis, main=main)
    }
if(do.ylab == FALSE) {stripchart(aldex.out[non.sig,x.axis] ~ aldex.out[non.sig,group.label],
    col=rgb(0,0,0,0.3), method="jitter", pch=19, xlim=xlim, xlab=x.axis, main=main, yaxt="n")
    }

draw.grey.boxes(as.vector(groups.set))

  stripchart(aldex.out[p.sig,x.axis] ~ aldex.out[p.sig,group.label],
    col=rgb(0,0,1,0.7),method="jitter", pch=19, add=T, cex=cex+0.2)

  stripchart(aldex.out[sig.pos,x.axis] ~ aldex.out[sig.pos,group.label],
    col=rgb(1,0,0,1),method="jitter", pch=19, add=T, cex=cex+0.2)
  stripchart(aldex.out[sig.neg,x.axis] ~ aldex.out[sig.neg,group.label],
    col=rgb(1,0,0,1),method="jitter", pch=19, add=T, cex=cex+0.2)

  abline(v=0, lty=2, col=rgb(0,0,0,0.2),lwd=2)
  abline(v=1, lty=3, col=rgb(0,0,0,0.2),lwd=2)
  abline(v= -1, lty=3, col=rgb(0,0,0,0.2),lwd=2)

}
