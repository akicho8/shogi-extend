#!/usr/bin/env Rscript
library(jsonlite)
records <- fromJSON("https://www.shogi-extend.com/api/lab/swars/grade_segment.json?json_type=general")
