
###                                        EXPLORING THE DATA

Intentos <- Intentoscsv

# A function to omit rows with NA's in specific columns    
completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}


## Average Contact Time for each TipoIncidencia level

# Dataset without NA's in time intervals (creation - call)    
Intentos <- completeFun(Intentos, "CreationCallInterval")
Intentos$CreationCallInterval <- as.integer(Intentos$CreationCallInterval)
Intentos$ImportationCallInterval <- as.integer(Intentos$ImportationCallInterval)


mean(Intentos$CreationCallInterval)
mean(Intentos$ImportationCallInterval)

# Setting only 2 levels for TipoIncidencia

Intentos$TipoIncidencia <- revalue(Intentos$TipoIncidencia, 
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

levels(Intentos$TipoIncidencia) <- list(ForwardedToDealer=c("ForwardedToDealer"), 
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

# Bar graph displaying Campaigns 

summary(Intentos$Campaña)
str(Intentos)


# Creating Column "Campaign" with shortened names
indexBehavioral_Ignition <- Intentos$DescripcionCampaña == "BEHAVIORAL TARG IGNITION ONE"
Intentos$Campaign[indexBehavioral_Ignition] <- "BT"

indexBehavioral_Oferta <- Intentos$DescripcionCampaña == "BEHAVIORAL TARGETING - OFERTA"
Intentos$Campaign[indexBehavioral_Oferta] <- "BT"

indexBehavioral_BTO <- Intentos$DescripcionCampaña == "BTO"
Intentos$Campaign[indexBehavioral_BTO] <- "BT"

index_CarConfigurator <- Intentos$DescripcionCampaña == "CAR CONFIGURATOR"
Intentos$Campaign[index_CarConfigurator] <- "Conf"

index_Compara <- Intentos$DescripcionCampaña == "COMPARA TU COCHE"
Intentos$Campaign[index_Compara] <- "Comp"

index_DriveK <- Intentos$DescripcionCampaña == "DRIVE-K"
Intentos$Campaign[index_DriveK] <- "DK"

index_Ecomov <- Intentos$DescripcionCampaña == "EVNETO ECOMOV VALENCIA"
Intentos$Campaign[index_Ecomov] <- "Eco"

index_CSS <- Intentos$DescripcionCampaña == "LEADS CSS"
Intentos$Campaign[index_CSS] <- "CSS"

index_CarWorld <- Intentos$DescripcionCampaña == "LLAMADA SOLICITUD PRUEBA DE VEHICULO - CAR WORLD"
Intentos$Campaign[index_CarWorld] <- "CW"

index_CarWorld2 <- Intentos$DescripcionCampaña == "LLAMADA SOLICITUD PRUEBA DE VEHíCULO - CAR WORLD"
Intentos$Campaign[index_CarWorld2] <- "CW"

index_PruebaOfertas <- Intentos$DescripcionCampaña == "LLAMADA SOLICITUD PRUEBA DE VEHICULO - PAGINA DE OFERTAS"
Intentos$Campaign[index_PruebaOfertas] <- "Ofe"

index_PruebaOfertas2 <- Intentos$DescripcionCampaña == "LLAMADA SOLICITUD PRUEBA DE VEHíCULO - PáGINA DE OFERTAS"
Intentos$Campaign[index_PruebaOfertas2] <- "Ofe"

index_PruebaConf <- Intentos$DescripcionCampaña == "LLAMADA SOLICITUD PRUEBA DINAMICA - CONFIGURADOR"
Intentos$Campaign[index_PruebaConf] <- "PD_Of"

index_InfoAteca <- Intentos$DescripcionCampaña == "MANTENME INFORMADO ATECA FR"
Intentos$Campaign[index_InfoAteca] <- "InfA"

index_InfoIbiza <- Intentos$DescripcionCampaña == "MANTENME INFORMADO NUEVO IBIZA"
Intentos$Campaign[index_InfoIbiza] <- "InfI"

index_QueCoche <- Intentos$DescripcionCampaña == "QUE COCHE ME COMPRO"
Intentos$Campaign[index_QueCoche] <- "QCC"

index_SMS <- Intentos$DescripcionCampaña == "SOLICITUD DE CONTACTO - SMS"
Intentos$Campaign[index_SMS] <- "SMS"

index_SEATES <- Intentos$DescripcionCampaña == "SOLICITUD DE TD SEAT.ES"
Intentos$Campaign[index_SEATES] <- "ES"

index_TESTB <- Intentos$DescripcionCampaña == "SOLICITUD PRUEBA DINAMICA TEST B"
Intentos$Campaign[index_TESTB] <- "TB"

index_MaratonGNC <- Intentos$DescripcionCampaña == "SOLICITUD TD MARATON GNC"
Intentos$Campaign[index_MaratonGNC] <- "GNC"

index_TiendaOnline <- Intentos$DescripcionCampaña == "TIENDA ONLINE"
Intentos$Campaign[index_TiendaOnline] <- "TO"

index_TiendaOnlineV1 <- Intentos$DescripcionCampaña == "TIENDA ONLINE V1"
Intentos$Campaign[index_TiendaOnlineV1] <- "TO1"

# Bar Graph showing number of leads for each campaign
ggplot(data = Intentos, aes(Intentos$Campaign)) + 
  geom_bar(stat = "count") +
  labs(x="Campaign", y="Number of Leads") +
  ggtitle("Number of Leads by Campaign")

# Creating Dataframe with only Campaign and Outcome

BarGraph <- cbind(Intentos$Campaign, Intentos$TipoIncidencia)
BarGraph <- as.data.frame(BarGraph)
names(BarGraph) <-c("Campaign", "Outcome")

BarGraph$Outcome <- as.numeric(BarGraph$Outcome)

FTD_index <- BarGraph$Outcome == "1"
BarGraph$Outcome[FTD_index] <- "FTD"

NotFTD_index <- BarGraph$Outcome == "2"
BarGraph$Outcome[NotFTD_index] <- "NotFTD"

#BarGraph$id <- rownames(BarGraph)
#BarGraphLong <- melt(BarGraph, id.vars = "id")

# Ploting campaign & Outcome
ggplot(BarGraph, aes(x = Campaign, y = Outcome,fill=Outcome)) +
  geom_bar(stat='identity' +
  ggtitle("Number of Leads by Campaign"))

