# Experiment 1

In this experiment, the GPT-2 model is tasked to compute surprisal values for the target pronouns 'he' and 'she' in sentences created by Davis and van Schijndel (2020).

## Data

The sentences provided by [Davis and van Schijndel (2020)](https://arxiv.org/abs/2010.04887) are stored in the file ```IC_mismatch.csv``` in the folder ```data```. Based on these sentences, we created 6888 stimulus sentences for the first experiment. We also make use of word frequency data ([SUBTLEX-US](https://www.ugent.be/pp/experimentele-psychologie/en/research/documents/subtlexus)), which was based on American English film subtitles. The word frequency data is also located in the folder ```data```.


## Jupyter Notebook

In the folder named ```code```, the Jupyter Notebook ```main_experiments.ipynb``` contained the script for all experiments with the GPT-2 language model. In this ```README.md``` file, we specifically focus on the section for Experiment 1 in the notebook.

### Dependencies
* [```transformers```](https://huggingface.co/docs/transformers/index)

### Usage
In the notebook, the pipeline for surprisal value generation is as follows:
* Install packages if necessary and import them;
* Load the dataset ```IC_mismatch.csv``` from the folder ```data``` and manipulate it;
* For each sentence in the obtained dataframe, compute the surprisal values for 'he' and 'she' as candidate upcoming words of the sentence;
* Compute the subject-preference scores (i.e. the difference between the suprisal values of 'he' and 'she', detailed in the paper);
* Save final dataframe as a ```csv``` file named ```experiment1_surprisals.csv``` for later data analysis in ```R```

## R
We use ```R``` to analyze the surprisal data we obtain from the previous step we describe above.
### Dependencies
* ```ggplot2```
* ```dplyr```
*  ```lmerTest```
*  ```MuMIn```

### Usage
In what follows, we describe the pipeline for data analysis for the first experiment:
* If necessary, install the libraries listed under Dependencies and load them;
* Load the datasets: (1) ```experiment1_surprisals.csv``` obtained from the previous step and (2) ```SUBTLEX-US.txt```, both are located in the folder ```data```;
* Visualize surprisal values against human bias scores;
* Create descriptive statistics;
* Regression models: regress human bias scores and gender of sentence subjects on subject-preference scores;
* Effect of word frequencies: regress word frequencies on the squared residuals of the above regression model.