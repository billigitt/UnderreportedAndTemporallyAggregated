---
output:
  pdf_document: default
  html_document: default
---
# UnderreportedAndTemporallyAggregated

This README.md file contains the current work and outline for our project on inferring the instantaneous reproduction number whilst accounts for temporally aggregated and under-reported incidence data.

## Terminology

$\rho$: Under-reporting
$I_t$: True incidence at time $t$
$\hat{I}_t$: Reported incidence at time $t$
$M$: Sample threshold in ABC algorithm

## Overview

Our project is broken down into 3 main sections (with main message in brackets):

# 1. Simple single study and large study (fixing true incidence) to show inference works (lower errors than Naive EE, correct coverage, robust for $M=10^5$)
# 2. Real world data set demonstrating that our method is a faster, more practical way of achieving desired inference.
# 3. Same large study  but stratified by $\rho$ (improving reporting leads to greater confidence in $R_t$ inference wrt credible intervals and mean error)
# 4. Real world data-set from an Ebola outbreak (showing that higher $\rho$ leads to narrower credible intervals but with RWD)

Key concept: Coefficient of variation, $CV = \sigma/\mu$.

## Checklist

+ Generate temporally aggregated incidence with $R_t=1.5$ and re-infer $R_t$ for Ebola epidemic with 'stuttering start', that is to say an epidemic that starts with 1 case on day 1. Allow epidemic to grow until it exceeds 1000 cases, then switch to $R_t=0.75$ for final 5 weeks. Only show inference for final 10 weeks. DONE.
+ Repeat inference for this epidemic with different values of $M$ ($10^3, 10^4, 10^5$) and 30 different times for each $M$. Use this to assess the robustness/consistency of inference for each value of $M$. DONE.
+ Run 1,000 epidemics and for each one generate 6 possible reported incidences (with $\rho = 0.33, 0.43, 0.53, 0.63, 0.73, 0.83$). Infer with correct knowledge of reporting rate. $R_t$ is sampled from a Gamma(shape = 1, scale = 3) distribution, as this ensures incidence does not get too high or too low. We then use this distribution as our prior when performing the inference. DONE.
+  Using these 6,000 inferences we can look at the coverage and the error. We look at the coverage over all values of $\rho$ and look at the distribution of correct coverage over all simulations, as well as what the total coverage is. This total coverage should be close to 95% since we use 2.5 and 97.5 credible intervals. For the error, we look at the distribution and calculate the mean error. DONE
+ We may need to qualify the significance of this distribution and the mean error. I have tried to do this by repeating the inference again but using a Naive Epi-Estim approach. DONE
+ Use real-world data-set to infer $R_t$ but now assuming different values of $\rho$. What does this do to $R_t$ inference (mean and credible intervals). DONE.

## Still to do (analysis):

+ Comparing our method with long-way of computing Rt. Currently running on cluster.
+ Re-run analyses for
  + $\rho = 0.3-0.9$?
  + Incidence generated a different way? Although now we have all simulated data-sets from same method (Gam(1,3) prior)
  + Entire Ebola data-set (took off 27 weeks)
  + Generating data with what value of P? Have assumed 7 so far.
+ Decide exactly on all the details of figures- colours, labels, etc. Suggest we iron these details out next meeting?

+ Start skeleton for manuscript?


## Section 1. Checking inference is accurate, approppriately covered(?) and robust.

We look at two case studies. Firstly, we look at a realistic outbreak. Secondly, we simulate a large number of epidemics, where the true $R_t$ values are sampled from the same gamma distribution that informs our prior.

![fig1](figs/sectionBasicInference/standardPlot.png)

*Fig 1: Single example showing that our inference is more accurate than EE, and has better coverage*

![fig2](figs/sectionBasicInference/mainFigureBasicInference.png)

*Fig 2: Large scale study showing our inference is both more precise and more accurate than EE. Mean errors are 19.8% vs 27.8% and mean coverages are 94.7% vs 73.1%*

![fig3](figs/sectionRobustness/mainRobustness.png)

*Fig 3: Clear demo that our method is more robust, and motivates why we choose M=100,000 (SUPP)*

## Section 2. Inference is comparable to implementing previous method over large range of possible true incidence (RWD)

Pending cluster computation. Idea: Reverse binomial sample (for each reported incidence of Ebola data) back to true incidence 1000 times. Then use old method to infer $R_t$. This inference (taking means of means and means of credible intervals) should then by identical to our inference (by eye).

## Section 3. Increasing $\rho$ leads to more accurate inference with appropriate coverage

![fig4](figs/sectionEffectOfRho/increasingRhoIsGood.png)

*Fig 4: Demo that increasing reporting rate leads to smaller errors and narrower credible intervals. Also that credible interval width is the same for EE and how coverage also depends on reporting for EE but not for our method.*

NB: We go back to simulated data here. Could this order be confusing for the reader? We have to decide between ordering sections by data-sets or ordering sections by principles of inference and then point about increasing $\rho$.

## Section 4. Verification that increasing $\rho$ leads to narrower credible intervals

![fig5](figs/sectionRWD/widthOfCrediblesDecreaseWithRho.png)

*Fig 5: Same point as Fig 4 but with real world data.*

NB: We do not do a large-scale study here and instead simulate reported incidence by choosing the most likely reporting given true incidence. This gives a simple, interpretable figure instead of re-running analyses to account for stochasticity.
NB: Do we want to zoom in on figure to really show the effect? Could have these two and then zoom in from weeks 30-40 showing the same panels below these?
