bibtex_2academic <- function(bibfile, outfold, overwrite = FALSE) {

  require(bib2df)
  require(dplyr)
  require(stringr)
  require(anytime)

  # detex <- function(x) {
  #   str_remove_all(x, "\\}\\}") %>%
  #     str_remove_all("\\{\\\\'\\{\\\\") %>%
  #     str_remove_all("\\{\\\\'\\{")
  # }
  #
  # Do some clean-up: remove latex-style accented characters and all
  # curly braces, and assign "categories" to publication types
  mypubs   <- bib2df(bibfile) %>%
    dplyr::mutate(TITLE  = stringr::str_remove_all(TITLE, "[{}]")) %>%
    dplyr::mutate(AUTHOR = stringr::str_remove_all(AUTHOR, "\\}\\}")) %>%
    dplyr::mutate(AUTHOR = stringr::str_remove_all(AUTHOR, "\\{\\\\'\\{\\\\")) %>%
    dplyr::mutate(AUTHOR = stringr::str_remove_all(AUTHOR, "\\{\\\\'\\{")) %>%
    dplyr::mutate(AUTHOR = stringr::str_remove_all(AUTHOR, "[{}]")) %>%
    dplyr::mutate(pubtype = dplyr::case_when(CATEGORY == "ARTICLE" ~ "2",
                                             CATEGORY == "INPROCEEDINGS" ~ "1",
                                             CATEGORY == "PROCEEDINGS" ~ "1",
                                             CATEGORY == "CONFERENCE" ~ "1",
                                             CATEGORY == "MASTERSTHESIS" ~ "3",
                                             CATEGORY == "PHDTHESIS" ~ "3",
                                             CATEGORY == "MANUAL" ~ "4",
                                             CATEGORY == "TECHREPORT" ~ "4",
                                             CATEGORY == "MANUAL" ~ "4",
                                             CATEGORY == "BOOK" ~ "5",
                                             CATEGORY == "INCOLLECTION" ~ "6",
                                             CATEGORY == "INBOOK" ~ "6",
                                             CATEGORY == "MISC" ~ "0",
                                             TRUE ~ "0"))

  create_md <- function(x) {

    filename <- paste(x[["DATE"]], x[["TITLE"]] %>%
                        str_replace_all(fixed(" "), "_") %>%
                        str_remove_all(fixed(":")) %>%
                        str_sub(1, 20) %>%
                        paste0(".md"), sep = "_")
    if (overwrite) {
      fileConn <- file.path(outfold, filename)
      write("+++", fileConn)
      write(paste0("title = \"", x[["TITLE"]], "\""), fileConn, append = T)
      write(paste0("date = \"", anydate(x[["DATE"]]), "\""), fileConn, append = T)

      # Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
      auth_hugo <- paste0(paste0("\"", x["AUTHOR"], "\""), collapse = ", ")
      write(paste0("authors = [", auth_hugo,"]"), fileConn, append = T)

      # Publication type.
      # Legend:
      # 0 = Uncategorized
      # 1 = Conference paper
      # 2 = Journal article
      # 3 = Manuscript
      # 4 = Report
      # 5 = Book
      # 6 = Book section
      write(paste0("publication_types = [\"", x[["pubtype"]],"\"]"), fileConn, append = T)

      # Publication name and optional abbreviated version.
      write(paste0("publication = \"", x[["JOURNALTITLE"]],"\""), fileConn, append = T)
      write(paste0("publication_short = \"", x[["ABBREV_SOURCE_TITLE"]],"\""),
            fileConn, append = T)

      # Abstract and optional shortened version.
      write(paste0("abstract = \"", x[["ABSTRACT"]],"\""), fileConn, append = T)
      write(paste0("abstract_short = \"","\""), fileConn, append = T)

      # Featured image thumbnail (optional)
      write("image_preview = \"\"", fileConn, append = T)

      # Is this a selected publication? (true/false)
      write("selected = false", fileConn, append = T)

      # Projects (optional).
      #   Associate this publication with one or more of your projects.
      #   Simply enter the filename (excluding '.md') of your project file in `content/project/`.
      #   E.g. `projects = ["deep-learning"]` references `content/project/deep-learning.md`.
      write("projects = []", fileConn, append = T)

      # Tags (optional).
      #   Set `tags = []` for no tags, or use the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
      write("tags = []", fileConn, append = T)

      # Links (optional).
      write(paste0("url_pdf = \"", paste0("https://doi.org/", x[["DOI"]], "\"")),
            fileConn, append = T)
      write("url_preprint = \"\"", fileConn, append = T)
      write("url_code = \"\"", fileConn, append = T)
      write("url_dataset = \"\"", fileConn, append = T)
      write("url_project = \"\"", fileConn, append = T)
      write("url_slides = \"\"", fileConn, append = T)
      write("url_video = \"\"", fileConn, append = T)
      write("url_poster = \"\"", fileConn, append = T)
      write("url_source = \"\"", fileConn, append = T)

      # Custom links (optional).
      #   Uncomment line below to enable. For multiple links, use the form `[{...}, {...}, {...}]`.
      # url_custom = [{name = "Custom Link", url = "http://example.org"}]

      # Does this page contain LaTeX math? (true/false)
      write("math = false", fileConn, append = T)

      # Does this page require source code highlighting? (true/false)
      write("highlight = true", fileConn, append = T)

      # Featured image
      # Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
      write("[header]", fileConn, append = T)
      write("image = \"\"", fileConn, append = T)
      write("caption = \"\"", fileConn, append = T)

      write("+++", fileConn, append = T)

      # close(fileConn)
    }
  }
  apply(mypubs, FUN = function(x) create_md(x), MARGIN = 1)
}
