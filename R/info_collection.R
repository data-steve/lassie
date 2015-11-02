# sends the responses to the google form
send_multiple_response <- function(err, err_funs, err_package, so_url, so_helped, secondary_url, secondary_helped){
  form_url <- "https://docs.google.com/forms/d/1EMMDafMMHMvj5LcLJuQjvkwS6WlLYghjNEoeCNMaQGo/formResponse" # ???????????
  httr::POST(
    form_url,
    query = list(
      `entry.2143305723`=err,  ## error
      `entry.259928126` = err_funs,
      `entry.759304580` = err_package,
      `entry.461821802`= so_url,   ## SO url
      `entry.1908271937`=so_helped,  ## SO Helped
      `entry.1574194484`=secondary_url,  ## GitHub url
      `entry.747979064`=secondary_helped    ## GitHub helped
    )
  )
}

## asks if the SO link was useful and collects the response
so_question <- function(message, opts = c("Yes", "No")){
  message(message)
  ans <- menu(opts)
  as.logical(2 - ans)
}

## asks if the secondary (GitHub/Google) link was useful and collects the response
secondary_question <- function(message, opts = c("Yes", "No, Post to StackOverflow", "No, Post to Github")){
  message(message)
  menu(opts)
}


