#how to add standard error to a plot of mean values

plot(var.mean ~ Date, data=mydata, pch=19, col=cols[treatment])
with(mydata, arrows(Date, var.mean, Date, var.mean+var.se,
                  angle=90, length=.03, col=cols[treatment]))
?arrows
#if we have a plot with Date on the xaxis we want to add vertical error bars
#so the length of the arrows is the point placement (x0, y0) +/- the standard error
# so x1 -s still = Date but y1 = var.mean + var.se
# we need to flatten and shorten the arrows (angle/length)--change them to see what happens
# copy the same color format you use for the regular points