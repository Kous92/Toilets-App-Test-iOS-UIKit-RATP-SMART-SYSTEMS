# Toilet App Test iOS (RATP SMART SYSTEMS)

Le test technique iOS officiel de RATP Smart Systems pour intégrer les équipes des applications Mappy et Bonjour RATP. Réalisé par Koussaïla BEN MAMAR, octobre 2022.

## Table des matières
- [Sujet du test](#testGoal)
    + [English](#english)
    + [Français](#french)
- [Solution proposée](#solution)
- [Améliorations futures](#futureImprovements)

## <a name="testGoal"></a>Test

### <a name="english"></a>English
Create a mini application that fetches the list of Public Toilets display them in a list.

Here is the list of information we would like to see for each toilet in the list:
- The address and opening hour of the toilet
- If it is accessible for people with reduced mobility (PRM : personnes à mobilité réduite)
- The distance from the current location if the location permission is given.
<br>

We would also like to see a filter that allows user to filter toilets proposing <i>**reduced mobility access**</i>.

Other non-required features but please consider them for your architecture !
- pagination
- offline access
- display all toilets on a map
- display toilet details on another screen

### Data source
`GET`: https://data.ratp.fr/api/records/1.0/search/?dataset=sanisettesparis2011&start=0&rows=1000 

*Documentation*: https://data.ratp.fr/explore/dataset/sanisettesparis2011/information/

### The application needs to:
- Be ready for production.
- Be easy to read and maintain by other developers.
- Have a commit history.
- Have an architecture ready to plug non-required features
- Have a README explaining the choices you made and what you would improve with more time available.

⚠️ Take your time. This is not a speed test.
When ready, send us a link to your app repository 🙏

### <a name="french"></a>Français

Créez une mini-application qui récupère les données des toilettes publiques et affichez-les dans une liste.

Voici une liste des informations que nous voudrions voir pour chaque toilette dans la liste:
- L'addresse et les heures d'ouvertures des toilettes
- Si c'est accessible PRM (personnes à mobilité réduite)
- La distance depuis votre position actuelle si la permission de localisation est donnée.
<br>

Nous voudrions aussi voir un filtre qui permet à l'utilisateur de filtrer les toilettes proposant <i>**l'accès aux personnes à mobilité réduite**</i>.

Autres fonctionnalités facultative mais merci de les considérer pour votre architecture !
- Pagination
- Accès hors ligne
- Afficher tous les toilettes dans une carte
- Afficher les détails des toilettes dans un autre écran

### Source de données
`GET`: https://data.ratp.fr/api/records/1.0/search/?dataset=sanisettesparis2011&start=0&rows=1000 

*Documentation*: https://data.ratp.fr/explore/dataset/sanisettesparis2011/information/

### Cette application doit:
- Être prête pour la mise en production.
- Être facile à lire et à maintenir par les autres développeurs.
- Avoir un historique de commits.
- Avoir une architecture prête à intégrer les fonctionnalités non requises.
- Avoir un README expliquant les choix que vous avez fait et ce que vous comptez améliorer avec plus de temps disponible.

⚠️ Prenez votre temps. Ce n'est pas un test de vitesse.
Dès que vous êtes prêts, envoyez-nous un lien vers le répertoire de votre application 🙏

## <a name="solution"></a>Solution proposée

Pour ce test technique, plusieurs challenges:
- La couche de données (data layer)
- L'architecture

Pour la partie du data layer, la principale difficulté est la synchronisation entre:
- Les données téléchargées de l'API REST
- La sauvegarde, le renouvellement et la récupération des données, en local.
- La position GPS pour la distance

Ici, mon idée est de faire la gestion des données en centralisant le tout dans une classe dédiée. Ce test est également une opportunité pour travailler avec **Core Data** afin de permettre l'utilisation de l'appli hors ligne (par la même occasion de réduire les calls de l'API REST, et donc la consommation de data notamment si on est en 3G/4G/5G).

## <a name="futureImprovements"></a>Améliorations futures

Si je dispose de davantage de temps.