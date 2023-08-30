# Horloge-parlante
Ce code propose une visualisation interactive du taux d’expression masculine et féminine sur plusieurs chaînes d'information (radio et télévision), pour différentes années et différentes heures de la journée.

[Visualisation complète dans l'application shiny](https://juliadescamps.shinyapps.io/media-horloge-parlante/)

## Données
[Les données](https://www.data.gouv.fr/fr/datasets/temps-de-parole-des-hommes-et-des-femmes-a-la-television-et-a-la-radio/) ont été récoltées par l’INA [(Doukhan & Carrive, 2018)]( https://www.isca-speech.org/archive/JEP_2018/pdfs/192838.pdf) : à partir de l’écoute de plus d’un million d’heure de programmes sur différentes chaînes de 1995 à 2019, un logiciel d’apprentissage automatique a permis de distinguer d’une part les plages de paroles des plages musicales. Il a ensuite pu déterminer le taux d’expression féminine et masculine pour chaque tranche horaire. Le taux d’expression féminine (resp. masculine) est défini comme le pourcentage de temps de parole attribué aux femmes (resp. aux hommes). 

J’ai choisi de me concentrer sur les principales chaînes d’information, excluant les chaînes exclusivement dédiées à la diffusion musicale. 

## Visualisation
De manière très triviale, j’ai construit une série de diagrammes circulaires (ou « camemberts ») qui, à une chaîne, une année et une heure donnée, affiche les taux d’expression masculine et féminine. Les diagrammes circulaires sont souvent critiqués pour les visualisations trompeuses qu’ils engendrent, accusés de sous-estimer ou surestimer certaines variables du fait d’une forme circulaire peu lisible. Puisque les données modélisées sont horaires, j’ai choisi d’exploiter cette forme souvent décriée, afin de superposer sur le graphique une horloge dont l’aiguille indique l’heure visualisée. Le but est d’offrir au lecteur une visualisation originale lui permettant de comparer la position de l’aiguille sur le cadran avec la répartition de la parole féminine et masculine effective à cet horaire. 

La fonction drawClock est une adaptation de la [fonction du même nom]( https://stackoverflow.com/questions/11877379/how-to-draw-clock-in-r) proposée par Paul Murrell dans son ouvrage <i>R graphics 2nd Edition</i>. 

Il est ensuite possible de créer un gif animé où l’aiguille se déplace sur le cadran, comme au cours d’une journée sur la chaîne en question, à année donnée. 

![alt text](https://github.com/JuliaDescamps/Horloge-parlante/blob/master/GIF/France%20Info_2019.gif)
