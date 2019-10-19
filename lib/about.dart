import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = TextStyle(
      height: 1.3,
    );

    TextStyle titleStyle = TextStyle(
      height: 1.3,
      fontSize: 30.0,
      fontFamily: 'SourceSansPro',
      color: Theme.of(context).primaryColor,
    );

    List<Widget> items = [
      Text(
        "Un service public numérique",
        style: titleStyle,
      ),
      Text(
        "Peps est une startup d'État dont l'objectif est d'accompagner les agriculteurs vers des pratiques économes en produits phytosanitaires.",
        style: bodyStyle,
      ),
      Text(
        "Le dispositif Startup d’Etat vise à utiliser les principes de fonctionnement des Startups pour répondre à un problème lié à une politique publique. Le service est ainsi co-conçu à partir d'atelier avec les acteurs du terrain. Une première version, même imparfaite, est lancée rapidement et améliorée par la suite avec le retours des agriculteurs et des acteurs du monde agricole. Au lieu de sortir dans 5 ans un produit a priori parfait mais jamais confronté au terrain, une Startup d'Etat lance un service public petit qu'elle fait grandir au fur et à mesure avec ses utilisateurs. L'objectif est de construire avec le terrain un service utile et utilisé.",
        style: bodyStyle,
      ),
      Text(
        "Une Start up d'Etat est un service public, elle est portée par une ou plusieurs administrations référentes. Peps est ainsi créé dans le cadre du plan Ecophyto. L'équipe de la Startup est cependant autonome dans les actions qu'elle mène et dans sa gestion du projet. Elle doit seulement rendre compte de son impact tous les 6 mois à son administration de référence. Ainsi, les données que vous partagez avec Peps resteront confidentielles.",
        style: bodyStyle,
      ),
      Text(
        "Concevoir avec et pour les utilisateurs",
        style: titleStyle,
      ),
      Text(
        "À l’instar des autres Startup d’État, l’équipe de Peps s’attache d'abord à comprendre les problématiques de chacune des parties prenantes pour créer un service adapté en synergie avec les outils et dynamiques existantes.",
        style: bodyStyle,
      ),
      Text(
        "Pour se faire, nous prenons contact avec toutes les personnes qui œuvrent sur le sujet et nous allons autant que possible au contact du terrain pour les rencontrer. Ainsi, Peps a organisé des journées de travail avec l'ensemble du monde agricole : agriculteurs, syndicats, DRAAF, DDT, Chambres d'agricultures, coopératives, association environnementale, CUMA. L'équipe Peps suit aussi des conseillers de coopératives et des agriculteurs dans leur journée de travail.",
        style: bodyStyle,
      ),
      Text(
        "Pour faire un service qui vous est utile, nous avons besoin de vous ! N'hésitez pas à nous solliciter si vous êtes intéressés.",
        style: bodyStyle,
      ),
      Text(
        "Nous nous focalisons sur l’impact",
        style: titleStyle,
      ),
      Text(
        "Peps ne sera pas un nouveau portail compilant autrement la documentation technique par ailleurs déjà diffusée par des sites développés depuis plusieurs années. Peps adopte un positionnement inexploité : l'orientation des agriculteurs dans leur transition. Peps oriente vers de pratiques éprouvées puis vers les organismes pouvant accompagner l'agriculteur en local.",
        style: bodyStyle,
      ),
      Text(
        "Nous avons 6 mois, c'est à dire jusqu'à mi-novembre, pour faire une preuve d'impact du service que nous développons. Cet impact est un témoignage que l'outil a apporté un service réel à l'agriculteur. Par exemple, l'agricuteur à engager une action qu’il n’aurait pas mis en œuvre sans.",
        style: bodyStyle,
      ),
    ];

    return Scaffold(
      key: Key('try_practice'),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Mise en place'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(15.0),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return items[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(8),
          );
        },
      ),
    );
  }
}
