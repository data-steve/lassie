# captures a warning/error
capture_warn_error <- function(x){
  tryCatch({
    x
  }, warning = function(w) {
    w
  }, error = function(e) {
    e
  })
}

## captures function name responsible for warning/error
capture_function <- function(x) {
  out <- tryCatch({
    x
  }, warning = function(w) {
    w[["call"]][[1]]
  }, error = function(e) {
    e[["call"]][[1]]
  })
  bad_fun <- deparse(out)
  if (bad_fun == "doTryCatch") {
    stop(paste0("Doesn't appear to be an object or function, ie, something we can do operations on.\n\n"
                , "Make sure:\n"
                , "\t1. There's no misspellings.\n"
                , "\t2. The function's package is loaded. (Use `library(package_name)`)\n"
                , "\t3. If it is a dataset, you've loaded the data. (See `?read.table`)"))

  }
  bad_fun
}
