# Survey-Statistics-Repo
Statistical Survey: Analysis of Simple and Complex Survey Samples 

# Website
[Please_go_to](http://my.ilstu.edu/~mxu2/Spring-2020/MAT450/MTH450.html)

# survey: Analysis of Complex Survey Samples
Summary statistics, two-sample tests, rank tests, generalised linear models, cumulative link models, Cox models, loglinear models, and 
general maximum pseudolikelihood estimation for multistage stratified, cluster-sampled, unequally weighted survey samples. Variances by Taylor
series linearisation or replicate weights. Post-stratification, calibration, and raking. Two-phase subsampling designs. Graphics. PPS sampling without 
replacement. Principal components, factor analysis.

Version:	3.37
Depends:	R (≥ 3.1.0), grid, methods, [Matrix](http://cran.fhcrc.org/web/packages/Matrix/index.html), [survival](http://cran.fhcrc.org/web/packages/survival/index.html)

Imports:	stats, graphics, splines, [lattice](http://cran.fhcrc.org/web/packages/lattice/index.html), [minqa](http://cran.fhcrc.org/web/packages/minqa/index.html),
[numDeriv](http://cran.fhcrc.org/web/packages/numDeriv/index.html), [mitools](http://cran.fhcrc.org/web/packages/mitools/index.html) (≥ 2.4)

Suggests:	[foreign](http://cran.fhcrc.org/web/packages/foreign/index.html), [MASS](http://cran.fhcrc.org/web/packages/MASS/index.html), [KernSmooth](http://cran.fhcrc.org/web/packages/KernSmooth/index.html),
[hexbin](http://cran.fhcrc.org/web/packages/hexbin/index.html), [RSQLite](http://cran.fhcrc.org/web/packages/RSQLite/index.html), [quantreg](http://cran.fhcrc.org/web/packages/quantreg/index.html), 
parallel, [CompQuadForm](http://cran.fhcrc.org/web/packages/CompQuadForm/index.html), [DBI](http://cran.fhcrc.org/web/packages/DBI/index.html), [AER](http://cran.fhcrc.org/web/packages/AER/index.html)

Author:	Thomas Lumley
Maintainer:	"Thomas Lumley" <t.lumley at auckland.ac.nz>
License:	[GPL-2](http://cran.fhcrc.org/web/licenses/GPL-2) | [GPL-3](http://cran.fhcrc.org/web/licenses/GPL-3)

URL:	[R-Survey-Project](http://r-survey.r-forge.r-project.org/survey/)


Citation:	[survey citation info](http://cran.fhcrc.org/web/packages/survey/citation.html)

In views:	OfficialStatistics, SocialSciences, Survival

CRAN checks:	[survey results](http://cran.fhcrc.org/web/checks/check_results_survey.html)

Downloads:
Reference manual: 	[survey.pdf](http://cran.fhcrc.org/web/packages/survey/survey.pdf)

Vignettes:	[Estimates in subpopulations](http://cran.fhcrc.org/web/packages/survey/vignettes/domain.pdf)
[Two-phase designs in epidemiology](http://cran.fhcrc.org/web/packages/survey/vignettes/epi.pdf)
Obsolete formulas for two-phase variances
Analysing PPS designs
[A survey analysis example](http://cran.fhcrc.org/web/packages/survey/vignettes/survey.pdf)

Package source: 	[survey_3.37.tar.gz](http://cran.fhcrc.org/src/contrib/survey_3.37.tar.gz)

Windows binaries: 	r-devel: [survey_3.37.zip](http://cran.fhcrc.org/bin/windows/contrib/4.0/survey_3.37.zip), r-devel-gcc8: [survey_3.36.zip](http://cran.fhcrc.org/bin/windows/contrib/r-devel-gcc8/survey_3.36.zip), 
r-release: [survey_3.37.zip](http://cran.fhcrc.org/bin/windows/contrib/3.6/survey_3.37.zip), r-oldrel: [survey_3.37.zip](http://cran.fhcrc.org/bin/windows/contrib/3.5/survey_3.37.zip) 

OS X binaries: 	r-release: survey_3.37.tgz, r-oldrel: survey_3.37.tgz 

Old sources: 	[survey archive](https://cran.r-project.org/src/contrib/Archive/survey)

Reverse dependencies:
Reverse depends:	CalibrateSSB, cjoint, hopit, lavaan.survey, mapStats, MedSurvey, MOJOV, pedgene, relaimpo, sae2, samplingbook, sptm, ssfit, StatMatch, svydiags, svyPVpack, twang, VIMGUI, weightTAPSPACK

Reverse imports:	aGE, anthro, capm, causaldrf, convey, cregg, dgo, DHS.rates, dvmisc, EffectLiteR, effects, egor, GB2, GJRM, httk, ICS, ICtest, jskm, jsmodule, jstable, mase, MatchThem, microsynth, OmnibusFisher, paramhetero, Plasmode, PNADcIBGE, poliscidata, pricesensitivitymeter, rareGE, RNHANES, robsurvey, srvyr, StroupGLMM, SUMMER, SvyNom, tab, tableone, Zelig

Reverse suggests:	apyramid, BIFIEsurvey, broom, car, finalfit, ggeffects, grattan, hutils, inca, inctools, insight, interactions, ipw, jtools, logmult, parameters, PracTools, Qtools, rdhs, RDS, SDaA, sirt, sjPlot, sjstats, WeightIt

Reverse enhances:	margins, prediction, stargazer, texreg

Linking:
Please use the canonical form https://CRAN.R-project.org/package=survey to link to this page.




Survey analysis in R
This is the homepage for the "survey" package, which provides facilities in R for analyzing data from complex surveys. The current version is 3.29. A much earlier version (2.2) was published in Journal of Statistical Software
An experimental package for very large surveys such as the American Community Survey can be found here
A port of a much older version of the survey package (version 3.6-8) to S-PLUS 8.0 is available from CSAN (thanks to Patrick Aboyoun at Insightful). 
Features: 
•	Means, totals, ratios, quantiles, contingency tables, regression models, loglinear models, survival curves,rank tests, for the whole sample and for domains. 
•	Variances by Taylor linearization or by replicate weights (BRR, jackknife, bootstrap, multistage bootstrap, or user-supplied) 
•	Multistage sampling with or without replacement. 
•	PPS sampling with or without replacement: Horvitz-Thompson and Yates-Grundy estimators and a range of approximations. 
•	Post-stratification, generalized raking/calibration, GREG estimation, trimming of weights. 
•	Two-phase designs. Estimated weights for augmented IPW estimators. 
•	Graphics 
•	Support for using multiply imputed data 
•	Database-backed design objects for large data sets (now with replicate weights, too) 
•	Some support for parallel processing on multicore computers. 
•	Multivariate analysis: principal components, factor analysis (experimental). 
•	Likelihood ratio (Rao-Scott) tests for glms, Cox models, loglinear models. 
The NEWS file gives a history of features and bug fixes. 
Comparison shopping:
Alan Zaslavsky keeps a comprehensive list of survey analysis software for the ASA Section on Survey Research Methods.
User-generated ratings and reviews of this package (and others) at crantastic. 
________________________________________
Using the survey package: 
•	Specifying a survey design 
•	Creating replicate weights 
•	Simple summary statistics 
•	Using supplied replicate weights 
•	Domain (subpopulation) estimation 
•	Tables of summary statistics 
•	Post-stratification and calibration 
•	Lonely PSUs 
•	Regression models 
•	Tests of association 
•	Stratification within PSUs 
•	Graphics 
•	Multiple imputation and ordinal logistic regression 
•	Database-backed survey objects 
•	Programming with survey objects 
________________________________________
Technical notes and comparisons with other software 
Some examples (in PDF) translated from Stata and SUDAAN examples at UCLA Academic Technology Services.
Notes on the sparse matrix algorithms used in version 3.15 for two-phase designs (and perhaps more widely in future versions)
Notes on standard errors for survival curves.
A 2009 CDC report compared five other survey analysis packages in the context of the Youth Risk Behaviors Survey. I have written an extension that does the same feature comparisons and results comparisons with R and the survey package. Some of this is copied from the CDC report (which I believe is in the public domain), but they are (of course) not responsible for any of the conclusions or results.
Anthony Damico has R scripts for downloading and analysing major US government surveys at Github. He reported on comparisons of the survey package with SAS, Stata, SUDAAN in The R Journal 1(2) 37-45 
________________________________________
Tutorials
I have a course at statistics.com, which will be repeated as demand permits
Here are slides from a Continuing Education course at JSM 2012.
I gave a workshop on two-phase designs at the 3rd North American Congress of Epidemiology, in Montreal, June 21,2011
I gave a two-day course for the Washington (DC) Statistical Society, March 23-24 2010. First day on R, second day on the survey package 
Norman Breslow and I gave the course at STATISTICALPS 2009, at the beginning of September in the Italian Alps. The course will include an introduction to the survey package, but will focus on two-phase designs in epidemiology. We will have some code and data up soon.
Slides from a short tutorial at the US Census Bureau, August 10.
I gave a tutorial at useR 2009, on the afternoon of July 7, 2009.
A 1.5 hour brief introduction to R, including a bit on the survey package, at the AAPOR conference, Friday May 15, 10:30am.
There was a one-day course at the University of Copenhagen Center for Health and Society on April 3, 2009. Slides are available at that link.
Tobias Verbeke has packaged data sets and exercises from Sharon Lohr's Sampling: Design and Analysis for use with the survey package.
I gave a short course for the Washington Statistical Society on March 15-16 2007. The first day was on R and the slides are a selection from these. The second day was on the survey package, slides here.
Norman Breslow and I gave a short course on complex survey designs for epidemiology at the 2008 WNAR (Biometric Society) meeting, UC Davis, June 22, 2008. My sessions were an overview of the survey package and an introduction to calibration. Norm's data sets and code are also online 
There is an article on version 3.6-12 of the package in the January 2008 issue of Survey Statistician (note: large PDF file)



