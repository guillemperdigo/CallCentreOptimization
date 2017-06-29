library(readxl)
library(plyr)
library(dplyr)
library(e1071)
library(caret)
library(lubridate)
library(tidyr)
library(gender)
library(genderizeR)
library(genderdata)
library(chron)
library(mlbench)
library(ISLR)
library(ggplot2)
library(grid)
library(gridExtra)
library(reshape)
library(reshape2)


Intentoscsv <- read.csv("~/MachineLearning/IntentosCualificacion.csv", header = TRUE, sep = ";")


#### ===================================== PREPROCESSING =====================================


###                                        DATES & TIMES

##  Creating DateTime columns
# Creation
    Intentoscsv$Fecha.de.creación <- as.Date(Intentoscsv$Fecha.de.creación, format = "%d/%m/%Y")
      Intentoscsv$CreationDateTime <- paste(Intentoscsv$Fecha.de.creación, Intentoscsv$HoraCreacion, sep=" ")
        Intentoscsv$CreationDateTime <- as.POSIXct(Intentoscsv$CreationDateTime, format = "%Y-%m-%d %H:%M:%S")
# Importation
    Intentoscsv$FechaImportación <- as.Date(Intentoscsv$FechaImportación, format = "%d/%m/%Y")
      Intentoscsv$ImportDateTime <- paste(Intentoscsv$FechaImportación, Intentoscsv$HoraImportación, sep=" ")
       Intentoscsv$ImportDateTime <- as.POSIXct(Intentoscsv$ImportDateTime, format = "%Y-%m-%d %H:%M:%S")
# Call
    Intentoscsv$FechaLlamada <- as.Date(Intentoscsv$FechaLlamada, format = "%d/%m/%Y")
      Intentoscsv$CallDateTime <- paste(Intentoscsv$FechaLlamada, Intentoscsv$HoraLlamada, sep=" ")
        Intentoscsv$CallDateTime <- as.POSIXct(Intentoscsv$CallDateTime, format = "%Y-%m-%d %H:%M:%S")

##  Time interval columns between each event
    Intentoscsv$CreationImportationInterval <- Intentoscsv$ImportDateTime - Intentoscsv$CreationDateTime # Creation
    Intentoscsv$CreationCallInterval <- Intentoscsv$CallDateTime - Intentoscsv$CreationDateTime # Importation
    Intentoscsv$ImportationCallInterval <- Intentoscsv$CallDateTime - Intentoscsv$ImportDateTime # Call

##  Weekday Column
    Intentoscsv$CreationWD <- weekdays(Intentoscsv$Fecha.de.creación) # Creation
    Intentoscsv$CallWD <- weekdays(Intentoscsv$FechaLlamada) # Call
  
##  Creating columns with time of each event not related to any date
    Intentoscsv$HoraCreacion <- times(Intentoscsv$HoraCreacion) # Creation
    Intentoscsv$HoraImportación <- times(Intentoscsv$HoraImportación) # Importation
    Intentoscsv$HoraLlamada <- times(Intentoscsv$HoraLlamada) # Call
  
##  Converting times to sinus and cosinus (otherwise 00:00 = 0 and 23:59 = 1)
# Creation
    Intentoscsv$sinCreacion <- as.numeric(sin(Intentoscsv$HoraCreacion))
      Intentoscsv$cosCreacion <- as.numeric(cos(Intentoscsv$HoraCreacion))
# Importation
    Intentoscsv$sinImportacion <- as.numeric(sin(Intentoscsv$HoraImportación))
      Intentoscsv$cosImportacion <- as.numeric(cos(Intentoscsv$HoraImportación))
# Call
    Intentoscsv$sinLlamada <- as.numeric(sin(Intentoscsv$HoraLlamada))
      Intentoscsv$cosLlamada <- as.numeric(cos(Intentoscsv$HoraLlamada))
  
  
###                                        GENDER
      
##  Separating name and surnames
    Intentoscsv <- extract(Intentoscsv, Nombre, c("FirstName", "LastName"), "([^ ]+) (.*)")
  
##  Names to proper case
    Intentoscsv$FirstName <- tolower(Intentoscsv$FirstName)
  
  simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
  }
  
  Intentoscsv$FirstName <- sapply(Intentoscsv$FirstName, simpleCap)
    
## Dataframe with final gender assigned to each name
# Defining period within people might have been born
  vectorMin <- as.vector(matrix(1920,nrow=26153))
  vectorMax <- as.vector(matrix(2000,nrow=26153))
  
    Intentoscsv$BirthYearMin <- vectorMin
    Intentoscsv$BirthYearMax <- vectorMax
    
      NameAndGender <- gender_df(Intentoscsv, name_col = "FirstName", year_col = c("BirthYearMin", "BirthYearMax"), 
                     method = c("ssa", "ipums", "napp", "demo"))
  
        colnames(Intentoscsv)[which(names(Intentoscsv) == "FirstName")] <- "name"
  
          NameAndGender$proportion_male <- NULL
          NameAndGender$proportion_female <- NULL
          NameAndGender$year_min <- NULL
          NameAndGender$year_max <- NULL
  
# Setting "Joan" to a male name
  indexJoan <- NameAndGender$name == "Joan"
  NameAndGender$gender[indexJoan] <- "male"
  
# Merging the gender column with the dataframe
  base1 <- (merge(NameAndGender, Intentoscsv, by = 'name'))
  base1 <- arrange(base1, IdRegistro, name)
  base1 <- base1[complete.cases(base1[ , 7]),]
  
      
  # Dataframe with male/female proportion for each name (finally not used)
  # Gender <- gender(Intentoscsv$FirstName, years = c(1932, 2012), 
  #                             method = c("ssa", "ipums", "napp","kantrowitz", "genderize", "demo"), 
  #                            countries = c("United States", "Canada","United Kingdom", "Germany", 
  #                                           "Iceland", "Norway", "Sweden"))
  
  base1$CreationImportationInterval <- as.numeric(base1$CreationImportationInterval)
  base1$CreationCallInterval <- as.numeric(base1$CreationCallInterval)
  base1$ImportationCallInterval <- as.numeric(base1$ImportationCallInterval)
  
  ### PLOTING TIME
  
  ggplot(base1, aes(x=CreationDateTime, y=CreationCallInterval) + geom_smooth() + geom_point())
  plot(base1$CreationDateTime, base1$CreationCallInterval)
    

###                                        CLEANING (BASE1)

# Deleting unnecessary columns
  base1$eMail <- NULL
  base1$Comentario.agente <- NULL
  base1$BirthYearMax <- NULL
  base1$BirthYearMin <- NULL
  base1$BirthYear <- NULL
  base1$IdAgente <- NULL
  base1$IdIntento <- NULL
  base1$HoraProximaLlamada <- NULL
  base1$name <- NULL
  base1$LastName <- NULL
  base1$IdRegistro <- NULL
  base1$Telefono <- NULL
  base1$Fecha.de.creación <- NULL
  base1$FechaLlamada <- NULL
  base1$FechaImportación <- NULL
  base1$DescripcionCampaña <- NULL
  base1$FechaProximaLlamada <- NULL
  base1$CreationDateTime <- NULL
  base1$ImportDateTime <- NULL
  base1$CallDateTime <- NULL
  
  base1 <- base1[complete.cases(base1), ]
  
  base1$CreationWD <- factor(base1$CreationWD)

# Factorizing variables again to avoid levels with no data

  levels(base1$TipoIncidencia)
  base1$TipoIncidencia <- revalue(base1$TipoIncidencia, 
                                                c("BoughtCar" = "BoughtCar",
                                                "CLIENTE DEVUELVE LLAMADA" = "ClienteDevuelveLlamada", 
                                                "ClosedCallAttempts" = "ClosedCallAttempts",
                                                "COMUNICA"="Comunica",
                                                "CONTESTADOR" = "Contestador",
                                                "DuplicatedLead" = "DuplicatedLead",
                                                "ENTREVISTA INCOMPLETA"="EntrevistaIncompleta", 
                                                "ENTREVISTA INCOMPLETA IDIOMA" = "EntrevistaIncompletaIdioma",
                                                "FALSE" = "False", 
                                                "ForwardedToDealer" = "ForwardedToDealer",
                                                "IncorrectData" = "IncorrectData",
                                                "LA LLAMADA NO PUEDE SER ESTABLECIDA" = "LaLlamadaNoPuedeSerEstablecida",
                                                "LLAMAR DE NUEVO" = "LlamarDeNuevo", 
                                                "LLAMAR MAS TARDE" = "LlamarMasTarde",
                                                "NO CONTESTAN" = "NoContestan", 
                                                "NotInterested" = "NotInterested",
                                                "NUMERO ERRONEO" = "NumeroErroneo",
                                                "Others" = "Others"))

# Setting only 2 levels for TipoIncidencia

  levels(base1$TipoIncidencia) <- list(ForwardedToDealer=c("ForwardedToDealer"), 
                                       NotFTD=c("BoughtCar",
                                                "ClienteDevuelveLlamada", 
                                                "ClosedCallAttempts",
                                                "Comunica",
                                                "Contestador",
                                                "DuplicatedLead",
                                                "EntrevistaIncompleta", 
                                                "EntrevistaIncompletaIdioma",
                                                "False",
                                                "IncorrectData",
                                                "LaLlamadaNoPuedeSerEstablecida",
                                                "LlamarDeNuevo", 
                                                "LlamarMasTarde",
                                                "NoContestan", 
                                                "NotInterested",
                                                "NumeroErroneo",
                                                "Others"))

# Creating a column that checks if the lead was created inside HorarioSecretel

  base1$HorarioSecretel <- as.numeric(base1$HoraCreacion > "09:00:00") & as.numeric(base1$HoraCreacion < "20:30:00")
  
  index <- base1$CreationWD == "sábado" | base1$CreationWD == "domingo"
  base1$HorarioSecretel[index] = FALSE
  
  base1$HoraCreacion <- NULL
  base1$HoraImportación <- NULL
  base1$HoraLlamada <- NULL
  base2 <- base1[,c('TipoIncidencia','Campaña','sinLlamada','cosLlamada')]
  
  as.numeric(base1$HoraCreacion)


## Manually checking for rules

# Creating a dataset for each gender

  indexm <- base1$gender == "male"
  basemale <- base1[indexm,]
  
  indexf <- base1$gender == "female"
  basefemale <- base1[indexf,]
  
  summary(basemale$TipoIncidencia)
  summary(basefemale$TipoIncidencia)


# Creating a dataset for each big campaign

  index019 <- base1$Campaña == "CPG-00000019"
  index439 <- base1$Campaña == "CPG-00001439"
  index214 <- base1$Campaña == "CPG-00022214"
  
  base019 <- base1[index019,]
  base439 <- base1[index439,]
  base214 <- base1[index214,]
  
  summary(base019$TipoIncidencia)
  summary(base439$TipoIncidencia)
  summary(base214$TipoIncidencia)
  


#### ===================================== PREDICTING THE OUTCOME =====================================
  
set.seed(3333)
    
    
###                                        TRAINING/TESTING & CONTROL 

##  Dividing the data: Training (75%) & Testing (25%)
    inTrain <- createDataPartition(y = base1$TipoIncidencia,
                                   p = .75,
                                   list = FALSE)
    training <- base1[inTrain,]
    testing <- base1[-inTrain,]
    
    training$TipoIncidencia <- factor(training$TipoIncidencia)
    testing$TipoIncidencia <- factor(testing$TipoIncidencia)
    
##  Control (algorithm parameters)
    ctrl <- trainControl(method = "cv",
                       classProbs = TRUE)
    

###                                        MODELS   
  
##  K Nearest Neighbors (KNN)
    knnFit <- train(TipoIncidencia ~ .,
                    data = training,
                    method = "knn",
                    trControl = ctrl,
                    tuneLength = 10)
    knnFit
    
    knnPredict <- predict(knnFit, newdata = testing)
    knnPredict
    summary(knnPredict)
    confusionMatrix(data = knnPredict, testing$TipoIncidencia)
  
    str(testing)
    summary(knnPredict)
    summary(testing$TipoIncidencia)

##  Support Vector Machine (SVM)
    svmFit <- train(TipoIncidencia ~ .,
                    data = training[1:3000,],
                    method = "svmLinear",
                    trControl = ctrl,
                    tuneLength = 5)
    svmFit
    
    svmPredict <- predict(svmFit, newdata = testing)
    svmPredict
    svmPredict <- droplevels(svmPredict)
    str(svmPredict)
    svmCM <- confusionMatrix(data = svmPredict, testing$TipoIncidencia)
    
    str(testing)
    summary(svmPredict)
    summary(testing$TipoIncidencia)

# Random Forest (RF)
  rfFit <- train(TipoIncidencia ~ .,
                  data = training,
                  method = "rf",
                  trControl = ctrl,
                  tuneLength = 10)
  rfFit
  
  rfPredict <- predict(rfFit, newdata = testing)
  rfPredict
  rfPredict <- droplevels(rfPredict)
  str(rfPredict)
  confusionMatrix(data = rfPredict, testing$TipoIncidencia)
  
  str(testing)
  summary(rfPredict)
  summary(testing$TipoIncidencia)

# Neural Network

  nnFit <- train(TipoIncidencia ~ .,
                  data = training,
                  method = "nnet",
                  trControl = ctrl,
                  tuneLength = 3)
  nnFit
  
  nnPredict <- predict(nnFit, newdata = testing)
  nnPredict
  nnPredict <- droplevels(nnPredict)
  summary(nnPredict)
  confusionMatrix(data = nnPredict, testing$TipoIncidencia)
  
  str(testing)
  summary(nnPredict)
  summary(testing$TipoIncidencia)
  
  training2 <- training[1:1000,]

# AdaBoost MODEL

  boostFit <- train(TipoIncidencia ~ .,
                 data = training2,
                 method = "adaboost",
                 trControl = ctrl,
                 tuneLength = 3)
  boostFit
  
  boostPredict <- predict(boostFit, newdata = testing)
  boostPredict
  boostPredict <- droplevels(boostPredict)
  str(boostPredict)
  confusionMatrix(data = boostPredict, testing$TipoIncidencia)
  
  str(testing)
  summary(boostPredict)
  summary(testing$TipoIncidencia)



## Checking for correlations between variables (Still working on it)

  lm1 <- lm(formula = TipoIncidencia ~ HoraLlamada, data = base1)
  
  correlations <- cor(base1[,unlist(lapply(base1, is.numeric))])
  
  anova1 <- aov(HoraLlamada ~ TipoIncidencia, data=base1)
  anova1



  #### ===================================== PREDICTING THE OUTCOME with a sample (50/50 FTD) =====================================
  
  ## Dataset with 50/50 of otucome success
  
  # Separating Base1 into FTD and NotFTD
  
  indexFTD <- base1$TipoIncidencia == "ForwardedToDealer"
  baseFTD <- base1[indexFTD,]
  
  indexNotFTD <- base1$TipoIncidencia == "NotFTD"
  baseNotFTD <- base1[indexNotFTD,]
  
  # Sampling 3492 NotFTD rows (we have that number of FTD instances)
  
  baseNotFTD3492 <- sample_n(baseNotFTD, 3492)
  
  base50 <- rbind(baseFTD, baseNotFTD3492)
  
  set.seed(3333)
  
  
  ###                                        TRAINING/TESTING & CONTROL 50/50
  
  ##  Dividing the data: Training (75%) & Testing (25%)
  inTrain50 <- createDataPartition(y = base50$TipoIncidencia,
                                 p = .75,
                                 list = FALSE)
  training50 <- base50[inTrain50,]
  testing50 <- base50[-inTrain50,]
  
  training50$TipoIncidencia <- factor(training50$TipoIncidencia)
  testing50$TipoIncidencia <- factor(testing50$TipoIncidencia)
  
  ##  Control (algorithm parameters)
  ctrl50 <- trainControl(method = "cv",
                       classProbs = TRUE)
  
  
  ###                                        MODELS 50/50   
  
  ##  K Nearest Neighbors (KNN) 50/50
  knnFit50 <- train(TipoIncidencia ~ .,
                  data = training50,
                  method = "knn",
                  trControl = ctrl,
                  tuneLength = 10)
  knnFit50
  
  knnPredict50 <- predict(knnFit50, newdata = testing50)
  knnPredict50
  summary(knnPredict50)
  confusionMatrix(data = knnPredict50, testing50$TipoIncidencia)
  
  str(testing50)
  summary(knnPredict50)
  summary(testing50$TipoIncidencia)
  
  ## KNN Normalizing
  
  # Normalizing Time Interval Columns (New Dataframe)
  
  base50Norm <- base50

  # Intervals to numeric
  base50Norm$CreationImportationInterval <- as.numeric(base50Norm$CreationImportationInterval)
  base50Norm$CreationCallInterval <- as.numeric(base50Norm$CreationCallInterval)
  base50Norm$ImportationCallInterval <- as.numeric(base50Norm$ImportationCallInterval)

  base50Norm[, 4:6] <- scale(base50Norm[, 4:6])
  
  ##  Dividing the data: Training (75%) & Testing (25%)
  inTrain50Norm <- createDataPartition(y = base50Norm$TipoIncidencia,
                                   p = .75,
                                   list = FALSE)
  training50Norm <- base50Norm[inTrain50Norm,]
  testing50Norm <- base50Norm[-inTrain50Norm,]
  
  training50Norm$TipoIncidencia <- factor(training50Norm$TipoIncidencia)
  testing50Norm$TipoIncidencia <- factor(testing50Norm$TipoIncidencia)
  
  # Model
  
  knnFit50Norm <- train(TipoIncidencia ~ .,
                    data = training50Norm,
                    method = "knn",
                    trControl = ctrl,
                    tuneLength = 10)
  knnFit50Norm
  
  knnPredict50Norm <- predict(knnFit50Norm, newdata = testing50)
  knnPredict50Norm
  summary(knnPredict50Norm)
  confusionMatrix(data = knnPredict50Norm, testing50$TipoIncidencia)
  
  ##  Support Vector Machine (SVM) 50/50
  svmFit50 <- train(TipoIncidencia ~ .,
                  data = training50,
                  method = "svmLinear",
                  trControl = ctrl,
                  tuneLength = 10)
  svmFit50
  
  svmPredict50 <- predict(svmFit50, newdata = testing50)
  svmPredict50
  svmPredict50 <- droplevels(svmPredict)
  str(svmPredict50)
  svmCM50 <- confusionMatrix(data = svmPredict50, testing50$TipoIncidencia)
  svmCM50
  str(testing50)
  summary(svmPredict50)
  summary(testing50$TipoIncidencia)
   
  # Random Forest (RF) 50/50
  rfFit50 <- train(TipoIncidencia ~ .,
                 data = training50,
                 method = "rf",
                 trControl = ctrl,
                 tuneLength = 5)
  rfFit50
  
  rfPredict50 <- predict(rfFit50, newdata = testing50)
  summary(rfPredict50)
  confusionMatrix(data = rfPredict50, testing50$TipoIncidencia)
  
  str(testing50)
  summary(rfPredict50)
  summary(testing50$TipoIncidencia)
  
  # Neural Network 50/50
  
  nnFit50 <- train(TipoIncidencia ~ .,
                 data = training50,
                 method = "nnet",
                 trControl = ctrl,
                 tuneLength = 10)
  nnFit50
  
  nnPredict50 <- predict(nnFit50, newdata = testing50)
  summary(nnPredict50)
  confusionMatrix(data = nnPredict50, testing50$TipoIncidencia)
  
  str(testing50)
  summary(nnPredict50)
  summary(testing50$TipoIncidencia)
