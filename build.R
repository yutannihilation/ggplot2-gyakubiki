library(qiitr)
library(rlist)
library(pipeR)
library(stringr)

q <- Qiita$new(readLines(file("token"), n = 1))

l <- q$get_item(tag_id = "ggplot2逆引き")

create_thumbnail <- function(item_id, images) {
  thumbdir <- file.path("thumbnails", item_id)
  dir.create(thumbdir, showWarnings = FALSE)
#  for (image in images) {
#    shell(sprintf('curl -k "%s" | convert - -resize 320x320 "%s/%s"', image, thumbdir, basename(image)))
#  }
  
  list.files(thumbdir, full.names = TRUE)
}

f <- file("qiita.json", "w", encoding = "UTF-8")

l %>>%
  list.map(~ list(url = jsonlite::unbox(.$url), title = jsonlite::unbox(.$title),
                  images = create_thumbnail(
                    item_id = .$id,
                    images = unlist(
                      str_extract_all(.$body, 'https://qiita-image-store.*.(png|gif)')
                    )
                  )
           )) %>>%
  jsonlite::toJSON(pretty = TRUE) %>>%
  writeLines(f)

close(f)

