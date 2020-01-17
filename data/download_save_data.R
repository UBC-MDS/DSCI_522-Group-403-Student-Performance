# author: Brayden Tang
# date: 2020-01-16
#
"This script grabs data from a provided url and then stores it in a given file path as a csv file.

Usage: download_save_data.R <url_link> --file_path=<file_path> [--file_name=<file_name>] [--delimiter=<delimiter>]

Options:
<url_link>                  A url link to a single data table, or a zip file with many files. If a .zip file is given, an argument to file_name must be given.
--file_path==<file_path>    The path to store the downloaded csv file in. Assumes this is given as an absolute path.
[--file_name=<file_name>]   An optional argument that gives the file name of the data table, for use if a .zip file is provided.
[--delimiter=<delimiter>]   A delimiter to provide. Optional. If none is provided, a comma is assumed.
" -> doc

library(tidyverse)
library(docopt)

#' This function grabs data from a speciified url and stores the file (named data.csv) in a specified file path. 
#'
#' @param url_link A character vector of length one that provides a URL linking to either a data table directly or a .zip file.
#' @param file_path A character vector of length one that specifies the path in which to store the downloaded data table as a csv file.
#' @param file_name A character vector of length one that gives the file name of the data in a .zip file. Only needed if the url_link
#'  provided points to a .zip file. Default = NULL.
#' @param delimiter The delimiter that seprates cells in the file. Default = NULL, in which case commas are assumed.
#'
#' @return NA
#' @export
#'
#' @examples
#'  main(
#'  "https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip", "repo/data", file_name = "set1.csv", delimiter = ";")
main <- function(url_link, file_path, file_name = NULL, delimiter = NULL) {
  
  if (str_detect(string = url_link, pattern = ".zip") == TRUE) {
  
    if (is.null(file_name)) {
      stop("If a zip file is provided as a link, file_name must be provided.")
    }
    
    temp <- tempfile()
    download.file(url_link, temp)
          
    data <- read_delim(unz(temp, file_name), delim = if_else(is.null(delimiter), ",", delimiter))
    unlink(temp)
    
    write_csv(x = data, path = paste(file_path, "/data.csv", sep = ""))
  
  } else {
    
    data <- read_delim(url_link, delim = if_else(is.null(delimiter), ",", delimiter))
    
    write_csv(x = data, path = paste(file_path, "/data.csv", sep = ""))
    
  }
  
}

opt <- docopt(doc)
main(url_link = opt$url_link, file_path = opt$file_path, file_name = opt$file_name, delimiter = opt$delimiter)
paste("File stored in", opt$file_path)
