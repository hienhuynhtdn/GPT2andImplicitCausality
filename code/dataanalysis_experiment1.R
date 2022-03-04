'''
GPT-2 AND IMPLICIT CAUSALITY

Experiment 1: Evaluating the next-word surprisal computation of the model.
Data Analysis
'''

# LIBRARIES
# Install the libraries used in this script
install.packages(c('ggplot2','dplyr','lmerTest','MuMIn'))
# Load the libraries
library(ggplot2)
library(dplyr)
library(lmerTest)
library(MuMIn)


# DATA PROCESSING
# Load next-word surprisal estimates
df <- read.delim("./data/experiment1_surprisals.csv", sep = ",",
                 stringsAsFactors = FALSE)
# Remove first column (indices) from df
df <- select(df, -c(1))

# Load word-frequency data
subtlex <- read.delim("./data/SUBTLEX-US.txt", sep = "",
                      stringsAsFactors = FALSE)
subtlex <- subtlex %>%
  select(Word, Lg10WF)
colnames(subtlex)[1] <- "verb"
colnames(subtlex)[2] <- "verb_logfreq"
# Merge subtlex with df
df <- left_join(df,subtlex,by="verb")


# VISUALIZATION
# Subject-preference (estimated by the model) vs Human bias scores (Ferstl et al., 2011)
ggplot(data = df, 
       aes(x   = bias,
           y   = subject_preference, 
           col = as.factor(subject_gender)))+
  geom_point(size     = 1, 
             alpha    = .7, 
             position = "jitter")+
  geom_smooth(method   = lm,
              se       = T, 
              size     = 1.5, 
              linetype = 1, 
              alpha    = .7,
              color = "darkgreen")+
  theme_minimal(base_size = 9)+
  scale_color_manual(name   ="Subject gender",
                     labels = c("Female", "Male"),
                     values = c("#F8766D","#00BFC4")) +
  scale_x_continuous("Human bias score") +
  scale_y_continuous("Model subject-preference score") +
  theme(aspect.ratio=1,
        panel.border = element_rect(fill=NA, size=0.5),
        plot.caption = element_text(hjust = 0.5))+
  labs(caption = expression("Object-biased verbs    " %<->% "    Subject-biased verbs"))


# DESCRIPTIVE STATISTICS
# Mean and SD of next-word suprisal values by (categories of) human bias scores
# and subject gender
df_1 <- df %>%
  mutate(bias_category=cut(bias, breaks=c(-100,-60,-20,20,60,100)))
# Male subjects: Mean and SD
df_1 %>%
  group_by(bias_category,subject_gender) %>%
  summarise(mean_he = mean(surprisal_he))
df_1 %>%
  group_by(bias_category,subject_gender) %>%
  summarise(sd_he = sd(surprisal_he))

# Female subjects: Mean and SD
df_1 %>%
  group_by(bias_category, subject_gender) %>%
  summarise(mean_she = mean(surprisal_she))
df_1 %>%
  group_by(bias_category, subject_gender) %>%
  summarise(sd_she = sd(surprisal_she))


# MIXED EFFECTS MODELS
# Model 1
model_1 <- lmer(subject_preference ~ bias * subject_gender + 
                 (1 + bias * subject_gender|item),
                data=df)
summary(model_1)
step(model_1)

# Model 2
model_2 <- lmer(subject_preference ~ bias * subject_gender + 
                 (1|item),
                data=df)
summary(model_2)
step(model_2)

# Model 3: Effect of word frequencies
# Residuals from Model 2
df$resid <- residuals(model_2)
df$resid_2 <- df$resid^2

# Drop NAs
df <- na.omit(df)

model_3 <- lmer(resid_2 ~ verb_logfreq + (1+verb_logfreq|item),
                data=df)
summary(model_3)
step(model_3)
