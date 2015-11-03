#' Help Understanding Errors and Warnings
#'
#' This function walks a user through the process of understanding errors and
#' warnings; providing applicable StackOverflow and GitHub or Google searches.
#' Last, helps the user to format a proper StackOverflow question or GitHub
#' issues post.
#'
#' @param \ldots Code that is giving an error or warning.
#' @keywords help question
#' @note This function cannot help with errors stemming from R's parser
#' rejecting the code as valid code. The error will occur before our function
#' will have been called. If such an error occurs, it means the code is not
#' well-formed. The following SO link gives common errors that fall into the
#' parse error class: \url{http://stackoverflow.com/q/25889234/1000343}.
#' @export
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' p <- 1:10
#' get_help(mean(LETTERS))
#'
#' get_help(3*"d")
#'
#' a1 <- c("a","a","b","b","c","d","e","e")
#' b2 <- c("01.01.2015", "02.02.2015", "14.02.2012", "16.08.2008",
#'     "17.06.2003", "31.01.2015", "07.01.2022", "09.05.2001")
#' c3 <- c("1a", "2b", "3c", "4d", "5e", "6f", "7g", "8h")
#' d3 <- c(1:8)
#'
#' df2 <- data.frame(a1,b2,c3,d3, stringsAsFactors = F)
#'
#' library(dplyr)
#' library(magrittr)
#'
#' get_help(
#'   df2 %>%
#'     group_by(a1) %>%
#'     as.Date(b2, format = "%d.%m.%Y")
#' )
#' }
get_help <- function(...){
  # assumptions they've found an error &
  # they must load our packages and rerun run the same code
  # the first argument to get_help is the function that through an error


  ###############################################
  #      GET PHASE
  ###############################################

  err <- capture_warn_error(...)

  # gsub spaces for pluses
  if (!inherits(err, "warning") & !inherits(err, "error")) {
      stop("This expression does not appear to throw an error or warning.")
  }
  err_funs <- deparse(err[["call"]][[1]])
  sessinfo <- sessionInfo()
  err_package <- package_functions(err_funs, sessinfo)

  so_url <- search_stackoverflow(err, err_funs, err_package)
  so_helped <- so_question("\nDid StackOverflow help?    (Enter number corresponding to choice.)")

  if (isTRUE(so_helped)) {
    send_multiple_response(err, err_funs, err_package,  so_url, so_helped, secondary_url = "", secondary_helped = "")
  } else {

    secondary_url <- github_google_search(err, err_funs, err_package, package_details(sessinfo))
    secondary_helped <- secondary_question("\nDid this help?  (Enter number corresponding to choice.)")

    send_multiple_response(err, err_funs, err_package,  so_url, so_helped, secondary_url, secondary_helped)

    if (!isTRUE(secondary_helped)) {
      ###############################################
      #      POST PHASE
      ###############################################
      temploc <- temp_template()
      make_template(temploc, so_url, secondary_url, secondary_helped, final.message = FALSE)
      readline(prompt="\nPlease:\n\t1. Fill in template \n\t2. Save\n\t3. Press [Enter] to continue...\n")
      make_post(temploc)

    }

  }

}

