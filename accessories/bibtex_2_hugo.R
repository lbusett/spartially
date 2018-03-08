bibtex_2academic <- function(bibfile, outfold, overwrite = FALSE) {

  require(RefManageR)
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
  mypubs   <- ReadBib(bibfile, check = "warn") %>%
    as.data.frame()
    # toBibtex(check = "warn") %>%
    # ReadBib() %>%
  mypubs   <- mypubs %>%
    dplyr::mutate(title  = stringr::str_remove_all(title, "[{}]")) %>%
    dplyr::mutate(author = stringr::str_remove_all(author, "\\}\\}")) %>%
    dplyr::mutate(author = stringr::str_remove_all(author, "\\{\\\\'\\{\\\\")) %>%
    dplyr::mutate(author = stringr::str_remove_all(author, "\\{\\\\'\\{")) %>%
    dplyr::mutate(author = stringr::str_remove_all(author, "[{}]")) %>%
    dplyr::mutate(pubtype = dplyr::case_when(document_type == "Article" ~ "2",
                                             document_type == "InProceedings" ~ "1",
                                             document_type == "Proceedings" ~ "1",
                                             document_type == "Conference" ~ "1",
                                             document_type == "MastersThesis" ~ "3",
                                             document_type == "PhdThesis" ~ "3",
                                             document_type == "Manual" ~ "4",
                                             document_type == "TechReport" ~ "4",
                                             document_type == "Book" ~ "5",
                                             document_type == "InCollection" ~ "6",
                                             document_type == "InBook" ~ "6",
                                             document_type == "Misc" ~ "0",
                                             TRUE ~ "0"))

  create_md <- function(x) {

    filename <- paste(x[["date"]], x[["title"]] %>%
                        str_replace_all(fixed(" "), "_") %>%
                        str_remove_all(fixed(":")) %>%
                        str_sub(1, 20) %>%
                        paste0(".md"), sep = "_")
    if (!file.exists(filename) | overwrite) {
      fileConn <- file.path(outfold, filename)
      write("+++", fileConn)
      write(paste0("title = \"", x[["title"]], "\""), fileConn, append = T)
      write(paste0("date = \"", anydate(x[["date"]]), "\""), fileConn, append = T)

      # Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
      auth_hugo <- str_replace_all(x["author"], " and ", "\", \"")

      write(paste0("authors = [\"", auth_hugo,"\"]"), fileConn, append = T)

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
      write(paste0("publication = \"", x[["journal"]],"\""), fileConn, append = T)
      write(paste0("publication_short = \"", x[["abbrev_source_title"]],"\""),
            fileConn, append = T)

      # Abstract and optional shortened version.
      write(paste0("abstract = \"", x[["abstract"]],"\""), fileConn, append = T)
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
      write(paste0("url_pdf = \"", paste0("https://doi.org/", x[["doi"]], "\"")),
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
