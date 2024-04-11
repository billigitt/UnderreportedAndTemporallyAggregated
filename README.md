---
output:
  pdf_document: default
  html_document: default
---
# UnderreportedAndTemporallyAggregated

This README file contains the current work and outline for our project on inferring thr instantaneous reproduction number whilst accounts for temporally aggregated and under-reported incidence data.

## Terminology

$\rho$: Under-reporting
$I_t$: True incidence at time $t$
$\hat{I}_t$: Reported incidence at time $t$
$M$: Sample threshold in ABC algorithm

## Overview

Our project is broken down into 3 main sections:

1. Demonstrate that inference works for typical value of under-reporting ($\rho=0.4$) for large value of $M = 10^3, 10^4, 10^5$. 
2. Fixing the true incidence, and considering different reporting rates to generate the reported incidence. Investigate $R_t$ inference and see how results vary for different values of $\rho$.
3. Finally using a real world data-set from an Ebola outbreak, investigate $R_t$ inference for different values of under-reporting.

The message from each section should take roughly the following form:

1. Inference works for a wide range of epidemics, with higher accuracy and precision when incidence is higher

For sections 2 and 3, we expect there to be a nuance between two factors. In general, higher assumed true incidence will lead to higher levels of precision in reproduction number inference. But there may be some interaction between that and the value of under-reporting assumed.

## Checklist


+ Generate temporally aggregated incidence with $R_t=1.5$ and re-infer $R_t$ for Ebola epidemic with 'stuttering start', that is to say an epidemic that starts with 1 case on day 1. Allow epidemic to grow until it exceeds 1000 cases, then switch to $R_t=0.75$ for final 5 weeks. Only show inference for final 10 weeks. DONE.
+ Repeat inference for this epidemic with different values of $M$ ($10^3, 10^4, 10^5$) and 30 different times for each $M$. Use this to assess the robustness/consistency of inference for each value of $M$. DONE.
+ Run 1,000 epidemics and for each one generate 6 possible reported incidences (with $\rho = 0.33, 0.43, 0.53, 0.63, 0.73, 0.83$). Infer with correct knowledge of reporting rate. $R_t$ is sampled from a Gamma(shape = 1, scale = 3) distribution, as this ensures incidence does not get too high or too low. We then use this distribution as our prior when performing the inference. DONE.
+  Using these 6,000 inferences we can look at the coverage and the error. We look at the coverage over all values of $\rho$ and look at the distribution of correct coverage over all simulations, as well as what the total coverage is. This total coverage should be close to 95% since we use 2.5 and 97.5 credible intervals. For the error, we look at the distribution and calculate the mean error. DONE
+ We may need to qualify the significance of this distribution and the mean error. I have tried to do this by repeating the inference again but using a Naive Epi-Estim approach. DONE

Still to do:

+ Use real-world data-set to infer $R_t$ but now assuming different values of $\rho$. What does this do to $R_t$ inference (mean and credible intervals)

## Section 1. Checking incidence is accurate.

We look at two case studies. Firstly, we look at a realistic outbreak. Secondly, we simulate a large number of epidemics, where the true Rt values are sampled from the gamma distribution that informs our prior.


![example simulation all incidence](figs/exampleSimulationIncidenceFull.png)
*Fig 1: Example simulation with $\rho = 0.4$*
![example simulation final 10 weeks](figs/exampleSimulationIncidenceLast10.png)
*Fig 2: Same example simulation with $\rho = 0.4$*
![epiestim imperfect info against ours](figs/OursVsEEImperfectInfo.png)
*Fig 3: Comparison of inference for simulation method vs Epi-Estim*
![epiestim perfect info against ours](figs/OursVsEEPerfectInfo.png)
*Fig 4: Comparison of inference for simulation method vs Epi-Estim (with perfect information)*
![robustness check](figs/robustnessCheckMean.png)
*Fig 5: Robustness check 1. Inference of same epidemic 30 different times for different values of M (and EpiEstim with perfect and imperfect information)*
Message for Fig 5: As $M$ increases, the mean estimate becomes more robust. 
![robustness check](figs/robustnessCheckUpper.png)
*Fig 6: Robustness check 2. Inference of same epidemic 30 different times for different values of M (and EpiEstim with perfect and imperfect information)*
Message for Fig 6: As $M$ increases, the upper percentile estimate becomes more robust. 
![robustness check](figs/robustnessCheckLower.png)
*Fig 7: Robustness check 3. Inference of same epidemic 30 different times for different values of M (and EpiEstim with perfect and imperfect information)*
Message for Fig 7: As $M$ increases, the lower percentile estimate becomes more robust. 
![relative error 6000 sims](figs/relativeError6000Sims.png)
*Fig 8: Relative error distribution over 6000 simulations*
Message for Fig 8: Over a wide range of epidemics and a broad spectrum of reporting rates, we find that the relative error distribution to take the following form, with mean value 19.8%.
NB: Do we need to qualify this somehow? Is 19.8% good or not? We can also investigate whether there is systematic over-estimation/under-estimation but this will probably be an artifact of what the true $R_t$ and serial intervals are. Perhaps, we simply state what the error is and then look at the coverage to indicate that the method works.
![relative error 6000 sims VS Naive EpiEstim](figs/relativeError6000SimsVsNaiveEpiEstim.png)
*Fig 9: Comparison of inference for simulation method vs Epi-Estim (with perfect information)*
![relative error 6000 sims against rho](figs/relativeError6000SimsVsRho.png)
This could replace Fig 8 if we want to compare our estimate and substantiate our claim more clearly.
*Fig 10: Comparison of inference for simulation method when different true values of rho are modelled*
Message for Fig 10: For the plausible range of $\rho$ values (0.33-0.83), we see that the error decreases as we reporting rates get higher. This message can be used to motivate higher recording rates in epidemics.
![coverage 6000 simulations](figs/coverage6000Sims.png)
*Fig 11: Looking at coverage for over many statistics*
Message for Fig 11: Along with the statistic that 94.8% of all credible intervals correctly contained the true reproduction number, this figure demonstrates that the coverage is consistent.

The following results demonstrate that there are conflicting outcomes when we set up an experiment with fixed reported incidence, and vary $\rho$.
![width of cri can decrease with rho](figs/widthOfCrediblesDecreaseWithRho.png)
*Fig 11: Inferences for two different $\rho$ values. Smaller $\rho$ gives wider credible intervals*

![width of cri can increase with rho](figs/widthOfCrediblesIncreaseWithRho.png)
*Fig 11: Inferences for six different $\rho$ values. Smaller $\rho$ gives narrower credible intervals*

We need to investigate why this happens. Argument Nic/Ed give is clear. Lower $\rho$ yields higher inferred true incidence, leading to higher certainty in $R_t$ inference. This argument breaks down if incidence is low.

A: If recorded incidence is low and rho is low, true incidence has a large coefficient of variation, and true incidence is variable?
B: If recorded incidence is low and rho is high, true incidence has a lower coefficient of variation, and true incidence is low.
C: If recorded incidence is high, then regardless of rho, we know incidence has a small coefficient of variation, and true incidence is high.

To get narrow credible intervals, we need both the true incidence to be high and to have a low coefficient of variation. This is satisfied in case C, and therefore only rho matters: lower rho leads to narrower credible intervals.

But between case A and B, it is not clear which will lead to wider credible intervals. A gives large CoV giving wide cri but incidence is not necessarily high or low. B gives certainty that true incidence is low but the lower CoV means that may lead to narrower cri.


