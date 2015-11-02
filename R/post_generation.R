make_post <- function(temploc, venue = "so"){

  if (!file.exists(temploc)) stop("This does not appear tp be the location of the 'question_template' file.")
  template <- read_template(temploc)

  ## check mandated fields
  manfields <- c('Title', 'Question', 'Description')
  missing_mandated <- grepl("^\\s*$", template[manfields])

  ## while loop forces these fields to be filled out
  if (any(missing_mandated)) {
    while(any(missing_mandated)){
      message(paste0(
        "The following mandatory fields are missing from the 'question_template':\n\n",
        paste(manfields[missing_mandated], collapse=", ")
      ))
      readline(prompt="\nPlease fill in these fields, save, and press [Enter] to continue...\n")
      template <- read_template(temploc)
      missing_mandated <- grepl("^\\s*$", template[manfields])
    }
  }

  ## check recommended fields
  recfields <- c('Data', 'Code', 'DesiredResult')
  missing_rec <- grepl("^\\s*$", template[recfields])

  ## if loop suggests these fields be filled out
  if (any(missing_rec)) {
    message(paste0(
      "The following recommended fields are missing from the 'question_template':\n\n",
      paste(recfields[missing_rec], collapse=", "),
      "\n\nThis could result in less attention and/or downvotes."
    ))
    readline(prompt="\nPlease fill in any of these fields you wish, next save the template, and then press [Enter] to continue...\n")
    template <- read_template(temploc)
  }

  ## Build post
  # Question and description
  question <- paste0("**", template[["Question"]], "**\n")
  description <- paste0("***Problem***\n\n", template[["Description"]], "\n")

  # Build MWE
  site <- switch(template[["Site"]],
      Github = "gh",
      StackOverflow = "so",
      "so"
  )

  contained_recfields <- names(template[c("Data", "Code")])[!grepl("^\\s*$", template[c("Data", "Code")])]
  if (any(c("Data", "Code") %in% recfields)) {

      if("Data" %in% contained_recfields) {
          mwe_data <- template[["Data"]]
      } else {
          mwe_data <- NULL
      }

      if("Code" %in% contained_recfields) {
          mwe_code <- template[["Code"]]
      } else {
          mwe_code <- NULL
      }
      mwe <- paste0(
          "***Minimal Working Example***\n\n",
          reprex_code(paste(c(mwe_data, mwe_code), collapse="\n"), venue = site)
      )

  } else {
    mwe <- NULL
  }

  if (!grepl("^\\s*$", template["DesiredResult"])) {

    # if so indent else ticks
    desired_out <- paste0("***Desired Output***\n\n", switch(site,
        so = {
            output <- strsplit(template["DesiredResult"], "\n")[[1]]
            if (output[1] == "") output <-output[-1]
            paste(paste0("    ", output), collapse="\n")
        },
        gh = {
            output <- strsplit(template["DesiredResult"], "\n")[[1]]
            if (output[1] == "") output <-output[-1]
            paste0("```r\n", paste(output, collapse="\n"), "\n```\n")
        },
        { # if missing use StackOverflow by default
            output <- strsplit(template["DesiredResult"], "\n")[[1]]
            if (output[1] == "") output <-output[-1]
            paste(paste0("    ", output), collapse="\n")
        }
    ))


  } else {
      desired_out <- NULL
  }


  # What I've tried
  so_url <- template[["StackOverflow"]]
  second_url <- template[["SecondaryUrl"]]
  urls <- template[c("StackOverflow", "SecondaryUrl")]
  tried <- sprintf(
      "I have already used [**helpr**]() to search [GitHub](%s) and [%s](%s) in an attempt to answer my question.",
      so_url,
      get_domain(second_url),
      second_url
  )

  #sessionInfo
  if (isTRUE(eval(parse(text=gsub("^\\s+|\\s+$", "", template[["SessionInfo"]]))))){
      sessinfo  <- switch(site,
          so = {
            sessinfoout <- utils::capture.output(sessionInfo())
            paste0("***Session Info***\n\n", paste(paste0("    ", sessinfoout), collapse="\n"))
          },
          gh = {
            sessinfoout <- utils::capture.output(sessionInfo())
            paste0("***Session Info***\n\n",paste0("```r\n", paste(sessinfoout, collapse="\n"), "\n```\n"))
          },
          { # if missing use StackOverflow by default
            sessinfoout <- utils::capture.output(sessionInfo())
            paste0("***Session Info***\n\n",paste(paste0("    ", sessinfoout), collapse="\n"))
          }
      )


  } else {
      sessinfo <- NULL
  }

  ## paste the pos together and write to clipboard
  thepost <- paste(c(question, description, mwe, desired_out, tried, sessinfo), collapase="\n\n")
  cat(thepost)
  clipr::write_clip(thepost)

  message(paste0(
    "Post written to the clipboard.\nAdd the following title to the question:\n\n",
    tools::toTitleCase(template[["Title"]])
  ))

  return(invisible(thepost))

}


## function to get url domain
get_domain <- function(x) {
  strsplit(gsub("http://|https://|www\\.", "", x), "/")[[c(1, 1)]]
}

## function that wraps reprex package to format code
reprex_code <- function(x, venue = "so", ...){
  temp <- tempdir()
  tempfl <- file.path(temp, "temp.R")
  cat(x, file=tempfl)
  out <- suppressWarnings(reprex::reprex(infile=tempfl, venue = venue,  show = FALSE, ...))
  paste(out, collapse="\n")
}
