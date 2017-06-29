# CallCentreOptimization
Call Centre Optimization

# El projecte d'Accenture

Aquest projecte s'enmarca dins les pràctiques extracurriculars a Accenture que estic duent a terme.

El meu projecte, per a una marca automovilística líder al mercat espanyol, té la missió d'augmentar les vendes que tenen com a origen els canals digitals. Actualment aquestes vendes representen un 4% del total; en acabar el projecte haurien de representar-ne un 10%.

## Què són les vendes a través de canals digitals?
Les vendes de cotxes per internet són gairebé inexistents, només existeixen alguns casos anecdòtics a Europa. Tot i així, els compradors cada cop més s'informen per internet i es dirigeixen al concessionari amb una decisió ja presa, simplement per a efeectuar la transacció final. Abans, els compradors visitaven diversos concessionaris i els comercials i catàlegs eren la font principal d'informació. 

Ara que els comercials han perdut poder, les marques necessiten el marketing digital per a convèncer els seus potencials compradors. A través de formularis, s'obtenen les dades de contacte dels potencials compradors. Aquests formularis generen una quantitat important de dades, la majoria de les quals de persones que no acabaran realitzant la compra per la qual s'han interessat. Els contactes obtinguts s'anomenen Leads generats.

Els Leads generats suposen un volum de dades que els concessionaris no poden afrontar sols: les marques, en general, disposen d'un Call Centre encarregat de posar-se en contacte amb el client, certificar el seu interès real en la compra (és la qualificació dels Leads). Els Leads traslladats són els que finalment arriben als concessionaris. Els dos passos finals d'aquest Journey són l'oferta i la compra. Quan es pot trackejar tot aquest camí realitzat per un client, s'assigna una venda als canals digitals.

## La importància d'optimitzar Call Centre
Només un 24% dels Leads generats són traslladats a concessionaris. El marge de millora és enorme, i és l'últim pas abans de la venda on la marca pot influenciar (després d'això se n'encarrega el concessionari, que és una entitat independent).

## Les dades
Disposem de 26.000 registres trucades realitzades entre el 2 de gener i el 30 de maig de 2017. A més de les dades personals dels clients, hi a el timestamp de la creació del lead, la importació a la base de dades del Call Centre i la trucada. També hi ha la campanya originària del lead, l'identificador de l'agent que ha realitzat la trucada, un comentari que deixa l'agent i l'outcome: Traslladat a Concessionari o no ( hi ha fins a 17 tipus de possibles outcomes "negatius")

## L'objectiu
Volem trobar un algoritme que faci una predicció de l'outcome. Cal identificar quines variables afecten més i quines menys, i en quines hi ha marge per a actuar. En última instància, cal definir una estratègia per millorar la ràtio de trasllat de leads als concessionaris.

## Exploració de les dades
Un examen exploratori de les dades mostra que les variables "Campanya", "Dia de la setmana de creació del Lead" i "Dia de la setmana de trucada" no mostren relació amb el percentatge d'èxit de les trucades. En canvi, la variable (creada per nosaltres) del "Temps de contacte" sí que hi té relació: com més aviat truquem el potencial comprador després de la creació del Lead, més probabilitats és que el traslladem a un concessionari.

## Prediccions
Un cop ordenades i netejades les dades, utilitzant el paquet caret hem provat diversos algoritmes. Per tal de poder mesurar millor la seva performance, hem agafat una mostra de dades amb el 50% d'èxit i el 50% de fracàs (en el datasaet global només hi ha un 25% d'èxit). Els diversos models utilitzats i la seva accuracy són aquests:
- knn: 58%
- svm: 57.5%
- random forest: 60.3%
- neural network: 59.5%

## Conclusions provisionals
De moment els algoritmes no donen prediccions prou bones com per implementar una estratègia basada en ells. Mentre continuem investigant, l'única estratègia que podem recomanar és trucar tan aviat com sigui possible.



