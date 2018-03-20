library("magick")

im.convert("flood/Urban_Flooding.pdf", 
           output = "Urban_Flooding.png",
           extra.opts="-density 150")

tiger <- image_read("flood/Urban_Flooding.pdf",density = "72x72")
tiger_png <- image_convert(tiger, "png")