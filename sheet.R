#pulls from Gdrive. Need authentication. Downloads whole folder as list of sheets.
data <- drive_get(id = "name of folder w all sheets", type = "spreadsheet")


clist <- data$schoolname
for (j in clist){
  for (i in seq(1, length(data), 1)){
    data[[i]]
    file <- gs_read(ws = "name of the specific sheet")
    file <- cbind(data[[i]], j)
    file <- drive_publish(data[[i]]) 
    file$published
  }
}

googlesheets::gs_ws_ls(result)
