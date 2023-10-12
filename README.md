# rENA demo
This is a demo of how to use rENA package on a dataset and to generate the stats result.

## Background
Epistemic Network Analysis (ENA) is a method used to identify meaningful and quantifiable patterns in discourse or reasoning. There is a great web toolkit available at [epistemicnetwork.org](https://www.epistemicnetwork.org/resources/). However, the website fails to run T-test and Wilcoxon  on datasets with more than ten dimensions. Therefore, a method to run those datasets locally to obtain the result is desired.

## The Demo
The demo script demonstrates how to use the rENA package to run ENA on a dataset. The script shows the result of T-test, Wilcoxon test and show the effect size Cohen'd. 

## Quick Start
1. Download the repository manually.
	Alternatively, you could clone the repository with the command:
	```cmd
	# Clone the repository
	git clone https://github.com/katcom/rENA-demo
	```
 2. Open the RStudio and set the current working directory to the folder in RStudio
	```
	setwd("some_path_to/rENA-demo")

	```
3. Load the libraries and read the dataset
	```
	library(readxl)
	library('rENA')
	library(data.table)
	
	# load data
	enaData <- read_excel(toString('data.xlsx'))
	
	```
4. Select the units and conversions for ENA. **You may want to change these variables when you build the ENA model on your own dataset**.
	```
	# selecting units for ENA
	units = c("groupid","username")
	
	# selecting conversation for ENA
	conversation = c("groupid", "username")
	
	# selecting code columns 
	codes = c('Q1', 'Q2', 'Q3', 'R1', 'R2','R3', 'S1', 'S2', 'S3','C1', 'C2', 'C3')
	
	```
5. Build the ENA model and run the analysis. Note that we set the param `runTest = True` so that the T-test and Wilcox are run once the model is built.
	```R
	# construct an ena object while running T-test and Wilcox
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
	```

6. Show the result
	```
	# show tests result
	print(ena_obj$tests)
	```
	The stats result should look like.
	```
	$wilcox.test
	$wilcox.test$test.dim1

		Wilcoxon rank sum exact test

	data:  group1.dim1 and group2.dim1
	W = 0, p-value = 0.3333
	alternative hypothesis: true location shift is not equal to 0


	$wilcox.test$test.dim2

		Wilcoxon rank sum exact test

	data:  group1.dim2 and group2.dim2
	W = 2, p-value = 1
	alternative hypothesis: true location shift is not equal to 0



	$t.test
	$t.test$test.dim1

		Welch Two Sample t-test

	data:  group1.dim1 and group2.dim1
	t = -6.6316, df = 1.0757, p-value = 0.08383
	alternative hypothesis: true difference in means is not equal to 0
	95 percent confidence interval:
	 -2.4289841  0.5782817
	sample estimates:
	 mean of x  mean of y 
	-0.4626756  0.4626756 


	$t.test$test.dim2

		Welch Two Sample t-test

	data:  group1.dim2 and group2.dim2
	t = 3.0654e-16, df = 1.1945, p-value = 1
	alternative hypothesis: true difference in means is not equal to 0
	95 percent confidence interval:
	 -6.318992  6.318992
	sample estimates:
		mean of x     mean of y 
	 5.551115e-17 -1.665335e-16 
	```

## Pitfalls
You should note that the calculated means from T-test and Wilcoxon are not the same as those from the web toolkit. The cause is still unknown. If you solve this problem, feel free to make a pull request.

We also include a stats function from [rENA API package](https://gitlab.com/epistemic-analytics/qe-packages/rENAPI/-/blob/main/R/group.stats.R?ref_type=heads) which runs different tests and calculate the stats on two groups. You could compare the result with ours. In our experiment, the mean values from the function are the same as the result of our test, and therefore differ from those on the web toolkit. 