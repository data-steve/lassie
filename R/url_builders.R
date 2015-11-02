# Make stackoverflow url from error and open link
search_stackoverflow <- function(err, err_funs, err_package){

  root <- "http://stackoverflow.com/search?q=%5Br%5D+"

  if (is(err, "error")) {
    url <- paste0(root, "r+error+", gsub(" +", "+",   err[["message"]])) #err_funs, "+", err_package, "+",
  } else {
    if (is(err, "warning")){
      url <- paste0(root, "r+warning+", gsub(" +", "+", err[["message"]])) # err_funs, "+", err_package, "+",
    } else {
      stop("this expression does not seem to throw an error or warning")
    }
  }
  utils::browseURL(url_fixer(url))
  return(invisible(url_fixer(url)))
}

## Make github/google url from error and open link
github_google_search <- function(error, funs, pack_name, details){
  pack_dets <- details[details$Package == pack_name, ]

  installed <- utils::installed.packages()
  basepacks <- installed[installed[,"Priority"] %in% c("base","recommended"), "Package"]

  if (!pack_name %in% basepacks && !is.na(pack_dets[["BugReports"]])) {
    url <- paste0(pack_dets[["BugReports"]], "/issues?q=", funs, "+", error)
  } else if (!pack_name %in% basepacks && pack_dets[["RepoType"]]=="github"){
    url <- paste0("https://github.com/"
                ,pack_dets[["RemoteUsername"]]
                , "/"
                , pack_dets[["RemoteRepo"]]
                ,"/issues?q=",funs, "+", error)
  } else {
      url <- paste0("http://www.google.com/#q=",
                                     paste( pack_dets[["RemoteUsername"]]
                                            ,  pack_dets[["RemoteRepo"]]
                                            , funs, error, collapse="+"))
  }
  utils::browseURL(url_fixer(url))

  return(invisible(url_fixer(url)))
}

## function to replace improper url characters
url_fixer <- function(x) {
  x <- iconv(x, to = "ASCII", sub = "")
  x <- gsub("%20", "[TEMP]", utils::URLencode(x))
  gsub("\\[TEMP\\]", "%20", gsub("\\+'\\.'\\+", "+", gsub("(\\+)?%[[:alnum:]]{2,4}", "", x)))
}


