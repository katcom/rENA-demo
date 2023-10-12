# rENA demo
This is a demo of how to use rENA package on a dataset and to generate the stats result.

## Background
Epistemic Network Analysis (ENA) is a method used to identify meaningful and quantifiable patterns in discourse or reasoning. There is a great web toolkit available at [epistemicnetwork.org](https://www.epistemicnetwork.org/resources/). However, the website fails to run T-test and Wilcoxon  on datasets with more than ten dimensions. Therefore, a method to run those datasets locally to obtain the result is desired.

## The Demo
The demo script demonstrates how to use the rENA package to run ENA on a dataset. The script shows the result of T-test, Wilcoxon test and show the effect size Cohen'd. 

## Pitfalls
You should note that the calculated means from T-test and Wilcoxon are not the same as those from the web toolkit. The cause is still unknown. If you solve this problem, feel free to make a pull request.

We also include a stats function from [rENA API package](https://gitlab.com/epistemic-analytics/qe-packages/rENAPI/-/blob/main/R/group.stats.R?ref_type=heads) which runs different tests and calculate the stats on two groups. You could compare the result with ours. In our experiment, the mean values from the function are the same as the result of our test, and therefore differ from those on the web toolkit. 