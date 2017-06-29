# Does the time from the lead creation to the call matter?

TimeMatters <- Intentos$TipoIncidencia

TimeMatters <- as.data.frame(TimeMatters)

TimeMatters$ContactTime <- Intentos$CreationCallInterval

TimeMatters$Outcome <- TimeMatters$TimeMatters
TimeMatters$TimeMatters <- NULL

# Seconds to Minutes
TimeMatters$ContactTime <- TimeMatters$ContactTime/60

TimeMatters2 <- TimeMatters
# First Hour
T10 <- as.data.frame(summary(TimeMatters$Outcome[TimeMatters$ContactTime < 10]))
T20 <- summary(TimeMatters$Outcome[TimeMatters$ContactTime < 20 & TimeMatters$ContactTime> 10])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 30 & TimeMatters$ContactTime> 20])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 40 & TimeMatters$ContactTime> 30])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 50 & TimeMatters$ContactTime> 40])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 60 & TimeMatters$ContactTime> 50])

# 1 - 4 hours
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 120 & TimeMatters$ContactTime> 60])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 180 & TimeMatters$ContactTime> 120])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 240 & TimeMatters$ContactTime> 180])

# 4 - 24 hours
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 360 & TimeMatters$ContactTime> 240])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 480 & TimeMatters$ContactTime> 360])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 600 & TimeMatters$ContactTime> 480])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 720 & TimeMatters$ContactTime> 600])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 840 & TimeMatters$ContactTime> 720])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 960 & TimeMatters$ContactTime> 840])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 1080 & TimeMatters$ContactTime> 960])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 1200 & TimeMatters$ContactTime> 1080])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 1320 & TimeMatters$ContactTime> 1200])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 1440 & TimeMatters$ContactTime> 1320])

# 24 - 72 hours
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 2160 & TimeMatters$ContactTime> 1440])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 2880 & TimeMatters$ContactTime> 2160])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 3600 & TimeMatters$ContactTime> 2880])
summary(TimeMatters$Outcome[TimeMatters$ContactTime < 4320 & TimeMatters$ContactTime> 3600])


# More than 72 hours
summary(TimeMatters$Outcome[TimeMatters$ContactTime > 4320])


plot(TimeMatters)




ggplot(TimeMatters, aes(x=ContactTime, fill = Outcome)) + 
  geom_histogram(binwidth = 25) +
  labs(x="Time (mins) from Lead Creation to Call", y="Number of Leads") +
  ggtitle("Contact Time") +
  theme_set(theme_gray(base_size = 18))

# Weekday Chart

WeekdayChart <- TimeMatters

WeekdayChart$Weekday <- Intentos$CreationWD

# Ordering the levels to get ordered weekdays
WeekdayChart$Weekday <- factor(WeekdayChart$Weekday, levels = c("lunes","martes","miércoles", 
                                                               "jueves", "viernes", "sábado", "domingo"))
# Ploting Leads Created by weekdays
ggplot(WeekdayChart, aes(x=Weekday, fill = Outcome)) + 
  geom_bar() +
  labs(y="Leads Created") +
  ggtitle("Success by day of the week (Lead Creation)") +
  theme_set(theme_gray(base_size = 16))

#Weekday Call

WeekdayChart$WDCall <- Intentos$CallWD
# Ordering the levels to get ordered weekdays
WeekdayChart$WDCall <- factor(WeekdayChart$WDCall, levels = c("lunes","martes","miércoles", 
                                                                "jueves", "viernes"))

# Ploting Success by WD Call
ggplot(WeekdayChart, aes(x=WDCall, fill = Outcome)) + 
  geom_bar() +
  labs(y="Leads Created") +
  ggtitle("Success by day of the week (Call))") +
  theme_set(theme_gray(base_size = 16))

# Supressing Residual Campaigns
WeekdayChart$Campaign <- Intentos$Campaign

indCW <- WeekdayChart$Campaign == "CW"
WeekdayChart$Campaign[indCW] <- NA

indGNC <- WeekdayChart$Campaign == "GNC"
WeekdayChart$Campaign[indGNC] <- NA

indInfA <- WeekdayChart$Campaign == "InfA"
WeekdayChart$Campaign[indInfA] <- NA

indOfe <- WeekdayChart$Campaign == "Ofe"
WeekdayChart$Campaign[indOfe] <- NA

indPD_Of <- WeekdayChart$Campaign == "PD_Of"
WeekdayChart$Campaign[indPD_Of] <- NA

indSMS <- WeekdayChart$Campaign == "SMS"
WeekdayChart$Campaign[indSMS] <- NA

indTB <- WeekdayChart$Campaign == "TB"
WeekdayChart$Campaign[indTB] <- NA

indSTO <- WeekdayChart$Campaign == "TO"
WeekdayChart$Campaign[indSTO] <- NA

indTO1 <- WeekdayChart$Campaign == "TO1"
WeekdayChart$Campaign[indTO1] <- NA
