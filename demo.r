library(readxl)
library('rENA')
library(data.table)

# you may need to set the path of your working directory to this folder in order to load the data.xlsx
# setwd("some_path_to/rENA-demo")

# load data
enaData <- read_excel(toString('data.xlsx'))

# selecting units for ENA
units = c("groupid","username")

# selecting conversation for ENA
conversation = c("groupid", "username")

# selecting code columns 
codes = c('Q1', 'Q2', 'Q3', 'R1', 'R2','R3', 'S1', 'S2', 'S3','C1', 'C2', 'C3')

# construct ena object with T-test and Wilcox
ena_obj = ena(
  data=as.data.frame(enaData),
  units = units,
  conversation = conversation,
  codes = codes,
  window.size.back = 4,
  runTest=TRUE,
  print.plots = FALSE,
  groupVar = "groupid",
  groups = c("1", "2")
)

# show tests result
print(ena_obj$tests)

# calculate cohen'd
## first calculate the occurrence vector
units_col = enaData[,c("groupid", "username")]
conversation_col = enaData[,c("groupid", "username")]
codes_col = enaData[,c('Q1', 'Q2', 'Q3', 'R1', 'R2','R3', 'S1', 'S2', 'S3','C1', 'C2', 'C3')]
accum = ena.accumulate.data(
  data=as.data.frame(enaData),
  units = units_col,
  conversation = conversation_col,
  codes = codes_col,
)

# setup the params for ena.make.set
accum$model$raw.input <- as.data.table(enaData);
accum$model$raw.input$ENA_UNIT <- merge_columns_c(accum$model$raw.input, units)

rotation_by = ena.rotate.by.mean
rotation_params = list(accum$meta.data[['groupid']] == '1', accum$meta.data[['groupid']] == '2')

set = ena.make.set(enadata=accum,rotation.by=rotation_by,rotation.params=rotation_params)

# get the rows of first group
group1.rows = accum$meta.data[['groupid']] == '1'
# get the rows of second group
group2.rows = accum$meta.data[['groupid']] == '2'

# get the points of first group, in first column(x-axis in the Web app)
group1.dim1 = as.matrix(set$points)[group1.rows,1]
# get the points of second group in first column(x-axis in the Web app)
group2.dim1 = as.matrix(set$points)[group2.rows,1]

# get the points of first group in second column(y-axis in the Web app)
group1.dim2 = as.matrix(set$points)[group1.rows,2]
# get the points of second group in second column(y-axis in the Web app)
group2.dim2 = as.matrix(set$points)[group2.rows,2]

# show the points on different dimensions
set$points

# show the cohen'd
fun_cohens.d(group1.dim1, group2.dim1)

# show the result of T-test on the first dimension. You should note that the result is not the same as that from the web toolkit.
# The cause is still unknown. If you solve this problem, feel free to make a pull request.
t.test(group1.dim1,group2.dim1)

# rENA package also have a function to calculate stats between two group, we could run the function on our dataset, and compare the results with ours. 

# load the stats function
source("group.stats.R")

# select all the demensions of group1 and group2
g1 = as.matrix(set$points[set$points$groupid==1])
g2 = as.matrix(set$points[set$points$groupid==2])

# run the stats
group.stats(g1,g2)