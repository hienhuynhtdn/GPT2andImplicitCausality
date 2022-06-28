'''
GPT-2 AND IMPLICIT CAUSALITY

Experiment 2: Evaluating the pipeline for text generation of the model
Data Analysis
'''

# LIBRARIES
# Install the libraries used in this script
install.packages(c('ggplot2','dplyr','gridExtra'))
# Load the libraries
library(ggplot2)
library(dplyr)
library(gridExtra)


# DATA PROCESSING
# Load text generation outputs
df <- read.delim("./data/experiment2_subject_reference.csv", sep = ",",
                 stringsAsFactors = FALSE)
# Remove first column (indices) from df
df <- select(df, -c(1))
# Drop NAs
df <- na.omit(df)
# Categorize human bias scores into slices
df_1 <- df %>%
  mutate(bias=cut(bias, breaks=c(-100,-60,-20,20,60,100)))


# VISUALIZATION
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
# Subject-remention: Did the model refer to the subjects in the clauses it generated?

# Count and % subject-remention by human bias score categories
summary <- df_1 %>% 
  group_by(bias,subject_reference) %>%
  tally %>%
  group_by(bias) %>%
  mutate(pct = n/sum(n))

df_2 <- df_1 %>%
  mutate(subject_gender = recode(subject_gender,
                                 "0"="Female subjects in stimuli",
                                 "1"="Male subjects in stimuli"))

# Count and % subject-remention by bias categories and subject gender
summary_2 <- df_2 %>% 
  group_by(bias,subject_reference,subject_gender) %>%
  tally %>%
  group_by(bias,subject_gender) %>%
  mutate(pct = n/sum(n))



plot_1 <- ggplot(summary, aes(x=bias, y=n, fill=as.factor(subject_reference))) +
  geom_bar(stat="identity") +
  geom_text(aes(label=paste0(sprintf("%1.1f", pct*100),"%")), 
            position=position_stack(0.95),colour="white",size=3) +
  theme_minimal(base_size = 9) +
  scale_x_discrete("Human bias score") +
  scale_y_continuous("count") +
  labs(tag="A") +
  labs(caption = expression("Object-biased verbs" %<->% "Subject-biased verbs")) +
  theme(aspect.ratio=1,
        panel.border = element_rect(fill=NA, size=0.5),
        axis.text.x = element_text(angle = 90),
        legend.position = "none",plot.tag.position = c(0.05,0.99),
        plot.caption = element_text(hjust = 0.5),
        plot.tag = element_text(face="bold"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()) +
  scale_fill_manual(values=cbPalette)

plot_2 <- ggplot(summary_2, aes(x=bias, y=n, fill=as.factor(subject_reference))) +
  geom_bar(stat="identity") +
  geom_text(aes(label=paste0(sprintf("%1.1f", pct*100),"%")), 
            position=position_stack(0.9),colour="white",size=2) +
  theme_minimal(base_size = 8) +
  scale_x_discrete("Human bias score") +
  scale_y_continuous("count") +
  labs(tag="B") +
  labs(caption = expression("Object-biased verbs" %<->% "Subject-biased verbs")) +
  theme(aspect.ratio=1,
        panel.border = element_rect(fill=NA, size=0.5),
        axis.text.x = element_text(angle = 90),
        plot.caption = element_text(hjust = 0.5),
        legend.position = "top",plot.tag.position = c(0.05,1),
        plot.tag = element_text(face="bold"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()) +
  facet_wrap(~subject_gender,nrow=1) +
  scale_fill_manual(name   ="Generated clauses referred to:",
                    labels = c("Previous \nobjects", "Previous \nsubjects"),
                    values = cbPalette)

grid.arrange(plot_1,plot_2, widths = c(1.5,2))
