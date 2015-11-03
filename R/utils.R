## get loaded packages from namespace
package_namespaces <- function(sessinfo){
  unlist(list(sessinfo$basePkgs, lapply(sessinfo[c("loadedOnly", "otherPkgs")], names)), use.names=FALSE)
}

# get the pckage(s) wthat contain a given function
package_functions <- function(fun, sessinfo){
   y <- sapply(sapply(package_namespaces(sessinfo), getNamespaceExports), function(x) fun %in% x)
   names(y[y])
}

## replace NULLS in the data.frame w/ NAs and then unlist (gives proper data.frame structure)
missing_unlister <- function(details){
  details[] <- lapply(details, function(x) {
        x[sapply(x, is.null)] <- NA
        unlist(x)
      })
  details
}

## function to strip emails from string
remove_emails <- function(details) {
  details[["Maintainer"]] <- sapply(strsplit(details[["Maintainer"]], " <"), "[" ,1)
  details
}

## function to grab/replace github urls
clean_up_github_issues_links_in_URL <- function(details){
    details[["URL"]] <- sapply(regmatches(details[["URL"]],
            gregexpr(
                "http(s?)://github\\.com\\/[a-zA-Z0-9]+\\/[a-zA-Z0-9]+[,]?",
                details[["URL"]],
                perl = TRUE
            )
        ), "[", 1)
    details
}

## function to grab to grab/replace github bug reports urls
paste_in_missing_bug_reports <- function(details) {
    details[["BugReports"]] <- sapply(regmatches(details[["BugReports"]],
            gregexpr(
                "http(s?)://github\\.com\\/[a-zA-Z0-9]+\\/[a-zA-Z0-9]+[,]?",
                details[["BugReports"]],
                perl = TRUE
            )
    ), "[", 1)
    details[is.na(details$BugReports), ][["BugReports"]] <- details[is.na(details$BugReports), ][["URL"]]
    details
}


## function to get a package's details from sessioInfo()
package_details <- function(sessinfo){
  sapply(c("Package","Repository", "Maintainer", "BugReports", "URL"
            , "RemoteType", "RemoteRepo", "RemoteUsername"
           ), function(x) {
    c(
      sapply(sessinfo[["loadedOnly"]], function(y) y[[x]]),
      sapply(sessinfo[["otherPkgs"]], function(y) y[[x]])
    )
  })  %>% data.frame(stringsAsFactors=FALSE)  %>%
  missing_unlister()  %>%

    remove_emails() %>%
    clean_up_github_issues_links_in_URL() %>%
    paste_in_missing_bug_reports()
}







