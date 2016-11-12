library(qiitr)
library(rlist)
library(pipeR)
library(stringr)
library(magick)

l <- qiita_get_items(tag_id = "ggplot2逆引き")

create_thumbnail <- function(item_id, image_urls) {
  thumbdir <- file.path("thumbnails", item_id)
  dir.create(thumbdir, showWarnings = FALSE)
  for (image_url in image_urls) {
    thumbfile <- file.path(thumbdir, basename(image_url))
    
    if (!file.exists(thumbfile)) {
      image_read(image_url) %>%
        image_scale("320x320") %>%
        image_write(thumbfile)
    }
  }
  
  list.files(thumbdir, full.names = TRUE)
}

f <- file("qiita.json", "w", encoding = "UTF-8")

l %>>%
  list.map(~ list(url = jsonlite::unbox(.$url),
                  title = jsonlite::unbox(.$title),
                  id = jsonlite::unbox(.$id),
                  images = create_thumbnail(
                    item_id = .$id,
                    image_urls = unlist(
                      str_extract_all(.$body, 'https://qiita-image-store.*.(png|gif)')
                    )
                  )
           )) %>>%
  jsonlite::toJSON(pretty = TRUE) %>>%
  writeLines(f)

close(f)

