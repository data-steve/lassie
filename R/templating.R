## make a blank response template
make_template <- function(temploc = "question_template.R", so_url = "",
    secondary_url = "", site = 2, open = TRUE, final.message = TRUE){

  ## basic tempalte
  template <- c("Title: ", "Question: ", "Description: ", "Data: ", "Code: ",
                "DesiredResult:", "SessionInfo: FALSE", "\n\n\nINTERNAL USE. DO NOT ALTER INFORMATION BELOW.",
                "TemplateLocation: %s", "StackOverflow: %s", "SecondaryUrl: %s", "Site: %s"
  )

  ## detemine if this will be a SO or GitHub post
  site <- switch(as.character(site), `2` = "StackOverflow", `3` = "Github")

  ## write out the tempalte populated with some user defined info
  cat(
      sprintf(
          paste(template, collapse="\n"),
          chartr("\\", "/", temploc),
          so_url,
          secondary_url,
          site
      ),
      file = temploc
  )

  ## message to tell how to include sessioInfo() in post
  message("Making template...\n\nIf you want to include `sessionInfo()` in the post mark\n`SessionInfo: TRUE` field in the template")

  ## Open the template
  if (open) {
    message("Opening question template...")
    file.edit(temploc)
  }

  ## message of what to do if you have jsut a template location
  if (isTRUE(final.message)) {
    message(paste0(
      "\nFill in the template fields*, save, and run `render_so` or `render_gh`\n\n",
      "*(1) 'Title:', (2) 'Question:', & (3) 'Description' are required fields."
    ))
  }

}


## make a template path location
temp_template <- function(template.directory = tempdir()){
  file.path(template.directory, "questionTemplate.R")
}


## function to read inthe template info
read_template <- function(temploc){

  ## read in the template info
  p <- suppressWarnings(readLines(temploc))

  ## Check for internal use line
  ## "^INTERNAL USE: DO NOT ALTER INFORMATION BELOW"
  internal_line <- grep("^INTERNAL USE: DO NOT ALTER INFORMATION BELOW", p)[1]

  if (is.na(internal_line)) {
    warning(paste0(
      "Template missing the line: `INTERNAL USE: DO NOT ALTER INFORMATION BELOW`\n",
      "Results may be incorrect."
    ))
  } else {
    while(grepl("^\\s*$", p[internal_line - 1])) {
      p <- p[-c(internal_line - 1)]
      internal_line <- grep("^INTERNAL USE\\. DO NOT ALTER INFORMATION BELOW\\.", p)[1]
    }
    p <- p[!grepl("^INTERNAL USE\\. DO NOT ALTER INFORMATION BELOW\\.", p)]
  }

  ## remove extra blank space space
  p <- fix_blank_line(p)
  p[!grepl("[A-Z][A-Za-z]+:", p)] <- paste0("    <|helpr|>", p[!grepl("[A-Z][A-Za-z]+:", p)])

  ## rewrite the template temporarily ro read back in with read.dcf
  temp <- tempdir()
  tempfl <- file.path(temp, "temp.R")
  cat(paste(p, collapse="\n"), file=tempfl)

  ## Read in the read.dcf
  fields_matrix <- gsub("[\n]+$", "", gsub("\\[\\[helpr_return\\]\\]", "",
      read.dcf(tempfl, fields = NULL, all = FALSE, keep.white = c("Data", "Code", "DesiredResult"))))

  ## sub out the extra space that was put in to be formatted for read.dcf
  fields_matrix <- gsub(
    "    <|helpr|>",
    "",
    gsub(
      "\n<|helpr|>",
      "",
      fields_matrix,
      fixed=TRUE
    ),
    fixed=TRUE
  )

  ## return return the fields to build the post
  stats::setNames(c(fields_matrix), colnames(fields_matrix))

}



fix_blank_line <- function(x){

  ## Grab empty elements locations
  locs <- grepl("^\\s*$", x)
  if (sum(locs) == 0) return(x)

  ## Remove beginning empty space
  while(isTRUE(locs[1])){
    x <- x[-1]
    locs <- grepl("^\\s*$", x)
  }

  ## Remove ending empty space
  while(length(x) %in% which(locs)){
    x <- x[seq_len(length(x) - 1)]
    locs <- grepl("^\\s*$", x)
  }

  ## Replace empties w/ return
  x[which(locs)] <- "[[helpr_return]]"
  x
}
