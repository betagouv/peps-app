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
        "Le dispositif Startup d’Etat vise à utiliser les principes de fonctionnement des Startups pour répondre à un problème lié à une politique publique. Le service est ainsi co-conçu à partir d'atelier avec les acteurs du terrain. L'objectif est de construire avec le terrain un service utile et utilisé.",
        style: bodyStyle,
      ),
      Text(
        "Une Start up d'Etat est un service public, elle est portée par une ou plusieurs administrations référentes. Peps est ainsi créé dans le cadre du plan Ecophyto.",
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
        "Pour se faire, nous prenons contact avec toutes les personnes qui œuvrent sur le sujet et nous allons autant que possible au contact du terrain pour les rencontrer. Ainsi, Peps a organisé des journées de travail avec l'ensemble du monde agricole : agriculteurs, syndicats, DRAAF, DDT, chambres d'agricultures, coopératives, associations environnementales, CUMA, et autres.",
        style: bodyStyle,
      ),
      Text(
        "Pour faire un service qui vous est utile, nous avons besoin de vous ! N'hésitez pas à nous solliciter si vous êtes intéressés.",
        style: bodyStyle,
      ),
      Text(
        "L'équipe",
        style: titleStyle,
      ),
      _TeamMember(
        image: AssetImage('assets/maud.png'),
        title: "Maud Blanck",
        subtitle: "Experte métier",
      ),
      _TeamMember(
        image: AssetImage('assets/mathilde.png'),
        title: "Mathilde Petit",
        subtitle: "Cheffe de produit informatique",
      ),
      _TeamMember(
        image: AssetImage('assets/ben.jpeg'),
        title: "Benjamin Doberset",
        subtitle: "Chargé de déploiement",
      ),
      _TeamMember(
        image: AssetImage('assets/alex.png'),
        title: "Alejandro M Guillén",
        subtitle: "CTO / Développement logiciel",
      ),
      Text(
        "Nos administrations référentes",
        style: titleStyle,
      ),
      Row(
        children: <Widget>[
          Flexible(
              child: Image.asset(
            'assets/ministere_agriculture.png',
            width: MediaQuery.of(context).size.width / 2,
          )),
          Flexible(child: Image.asset('assets/ministere_ecologie.jpg', width: MediaQuery.of(context).size.width / 2)),
        ],
      ),
      Row(
        children: <Widget>[
          Flexible(
              child: Image.asset(
            'assets/ecophyto.png',
            width: MediaQuery.of(context).size.width / 2,
          )),
          Flexible(
              child: Image.asset(
            'assets/inra.jpg',
            width: MediaQuery.of(context).size.width / 2,
          )),
        ],
      ),
    ];

    return Scaffold(
      key: Key('try_practice'),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Qui sommes-nous ?'),
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

class _TeamMember extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;

  _TeamMember({this.image, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
        width: 70.0,
        height: 70.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: this.image,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 18, height: 1.3),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey, height: 1.3),
            ),
          ],
        ),
      ),
    ]);
  }
}
