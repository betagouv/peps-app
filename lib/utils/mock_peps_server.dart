import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/testing.dart';

class MockPepsServer extends MockClient {
  static final MockClientHandler fn = (request) async {
    final path = request.url.path;
    final responseHeaders = {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'};

    if (path == '/api/v1/formSchema') {
      return Response(formSchema, HttpStatus.ok, headers: responseHeaders);
    }

    return Response(json.encode({}), HttpStatus.notFound, headers: responseHeaders);
  };

  MockPepsServer() : super(fn);

  // It would be easier to load from an asset but it's not possible
  // at the moment : https://github.com/flutter/flutter/issues/21931
  static final String formSchema = """
    {
      "schema": {
          "description": "Optimisez votre système de culture",
          "type": "object",
          "properties": {
              "problem": {
                  "title": "Quel problème souhaitez-vous résoudre actuellement ?",
                  "required": false
              },
              "pests": {
                  "title": "Quels ravageurs vous posent problème aujourd\'hui dans votre exploitation ?",
                  "required": false
              },
              "glyphosate": {
                  "title": "Quel est votre principal usage du glyphosate ?",
                  "required": false
              },
              "weeds": {
                  "title": "Quelles adventices vous posent problème aujourd\'hui dans votre exploitation ?",
                  "required": false
              },
              "weedsGlyphosate": {
                  "title": "Quelles adventices vous posent problème aujourd\'hui dans votre exploitation ?",
                  "required": false
              },
              "perennials": {
                  "title": "Quelles vivaces vous posent problème aujourd\'hui dans votre exploitation ?",
                  "required": false
              },
              "practices": {
                  "title": "Quelles pratiques avez-vous déjà essayées pour répondre à ce problème ?",
                  "required": false
              },
              "tillage": {
                  "title": "Quels types de travail du sol pouvez-vous intégrer dans votre système ?",
                  "required": false
              },
              "cattle": {
                  "title": "Avez-vous un atelier d’élevage ou disposez vous d’un débouché possible en alimentation animale ?",
                  "required": false,
                  "enum": [
                      "Oui",
                      "Non"
                  ]
              },
              "rotation": {
                  "title": "Dans l\'ordre, quelles cultures composent la rotation des parcelles sur lesquelles vous rencontrez ce problème ?",
                  "required": false,
                  "uniqueItems": false,
                  "items": {
                      "required": true
                  }
              },
              "department": {
                  "title": "Quel est le département de votre exploitation ?",
                  "required": false
              },
              "groups": {
                  "title": "Faites-vous partie de groupes ou d\'initiatives travaillant sur la réduction des produits phytosanitaires ?",
                  "required": false,
                  "logAnswer": true
              },
              "referer": {
                  "title": "Comment avez-vous connu Peps ?",
                  "required": false,
                  "logAnswer": true
              }
          },
          "dependencies": {
              "pests": [
                  "problem"
              ],
              "weeds": [
                  "problem"
              ],
              "weedsGlyphosate": [
                  "glyphosate"
              ],
              "perennials": [
                  "glyphosate"
              ],
              "glyphosate": [
                  "problem"
              ]
          }
      },
      "options": {
          "form": {
              "attributes": {
                  "method": "post",
                  "action": "/api/practices"
              }
          },
          "fields": {
              "problem": {
                  "sort": false,
                  "hideNone": true,
                  "type": "radio",
                  "focus": false,
                  "emptySelectFirst": false,
                  "dataSource": [
                      {
                          "text": "Mieux gérer les adventices",
                          "value": "DESHERBAGE"
                      },
                      {
                          "text": "Lutter contre les ravageurs",
                          "value": "RAVAGEURS"
                      },
                      {
                          "text": "Réduire ma consommation des produits phytosanitaires",
                          "value": "DEPENSE"
                      },
                      {
                          "text": "Éviter des maladies fongiques",
                          "value": "MALADIES_FONGIQUES"
                      },
                      {
                          "text": "Sortir du glyphosate",
                          "value": "GLYPHOSATE"
                      },
                      {
                          "text": "Autres",
                          "value": "AUTRES"
                      }
                  ]
              },
              "pests": {
                  "hideNone": true,
                  "sort": true,
                  "type": "checkbox",
                  "multiple": true,
                  "dependencies": {
                      "problem": "RAVAGEURS"
                  },
                  "dataSource": [
                      {
                          "text": "Mélighètes",
                          "value": "recqwipvZ8hYkqoW2"
                      },
                      {
                          "text": "Charançons",
                          "value": "recEAzBkErChPR5QD"
                      },
                      {
                          "text": "Pucerons",
                          "value": "recJ8yDp6efuj0qA7"
                      },
                      {
                          "text": "Altises",
                          "value": "recEbpaMFaFY4mtG6"
                      },
                      {
                          "text": "Cecidomyies",
                          "value": "rec4B3jxtXKzRU7TY"
                      },
                      {
                          "text": "Limaces",
                          "value": "recXB2xQs6PDsHl3N"
                      },
                      {
                          "text": "Pyrales",
                          "value": "recm2wdFzUylhmtuX"
                      },
                      {
                          "text": "Cicadelles",
                          "value": "rec8aiRrr8oHilfCX"
                      },
                      {
                          "text": "Doryphores",
                          "value": "rec4Pb8L6FAwI9xzc"
                      },
                      {
                          "text": "Sésamie",
                          "value": "recHgrVU6GZ03oBsr"
                      },
                      {
                          "text": "Noctuelle",
                          "value": "recNDSOlAzB6icTKd"
                      },
                      {
                          "text": "Taupin",
                          "value": "recPvUA7DQRw2RtrO"
                      }
                  ]
              },
              "weeds": {
                  "hideNone": true,
                  "sort": true,
                  "type": "checkbox",
                  "multiple": true,
                  "dependencies": {
                      "problem": [
                          "DESHERBAGE"
                      ]
                  },
                  "dataSource": [
                      {
                          "text": "Ray-grass",
                          "value": "recjzIBqwGkton9Ed"
                      },
                      {
                          "text": "Chardon des champs",
                          "value": "recZkVZESGvUlCtNi"
                      },
                      {
                          "text": "Liseron",
                          "value": "recBD6n3k77eFRHES"
                      },
                      {
                          "text": "Vulpin des champs",
                          "value": "recTFtGv6zIdKbACJ"
                      },
                      {
                          "text": "Rumex",
                          "value": "rec2wnpJOAJzUFe5v"
                      },
                      {
                          "text": "Laiteron rude",
                          "value": "recpsKrpvDjjLVIj0"
                      },
                      {
                          "text": "Gaillet gratteron",
                          "value": "rectzRHGBUn6irB3h"
                      },
                      {
                          "text": "Géranium",
                          "value": "recG4WVqpfd0UoGDH"
                      },
                      {
                          "text": "Ambroisie à feuille d\'armoise",
                          "value": "recoT32VVO4hMRWiY"
                      },
                      {
                          "text": "Orobanche",
                          "value": "rec6ucMhh5sgzDfty"
                      },
                      {
                          "text": "Véronique de Perse",
                          "value": "recSH8679Tbxcc3RT"
                      },
                      {
                          "text": "Chenopode blanc",
                          "value": "rec1nKcBZmxndYsZB"
                      }
                  ]
              },
              "weedsGlyphosate": {
                  "hideNone": true,
                  "sort": true,
                  "type": "checkbox",
                  "multiple": true,
                  "dependencies": {
                      "glyphosate": [
                          "COUVERTS",
                          "PARCELLES",
                          "PRAIRIES",
                          "AUTRES"
                      ]
                  },
                  "dataSource": [
                      {
                          "text": "Ray-grass",
                          "value": "recjzIBqwGkton9Ed"
                      },
                      {
                          "text": "Chardon des champs",
                          "value": "recZkVZESGvUlCtNi"
                      },
                      {
                          "text": "Liseron",
                          "value": "recBD6n3k77eFRHES"
                      },
                      {
                          "text": "Vulpin des champs",
                          "value": "recTFtGv6zIdKbACJ"
                      },
                      {
                          "text": "Rumex",
                          "value": "rec2wnpJOAJzUFe5v"
                      },
                      {
                          "text": "Laiteron rude",
                          "value": "recpsKrpvDjjLVIj0"
                      },
                      {
                          "text": "Gaillet gratteron",
                          "value": "rectzRHGBUn6irB3h"
                      },
                      {
                          "text": "Géranium",
                          "value": "recG4WVqpfd0UoGDH"
                      },
                      {
                          "text": "Ambroisie à feuille d\'armoise",
                          "value": "recoT32VVO4hMRWiY"
                      },
                      {
                          "text": "Orobanche",
                          "value": "rec6ucMhh5sgzDfty"
                      },
                      {
                          "text": "Véronique de Perse",
                          "value": "recSH8679Tbxcc3RT"
                      },
                      {
                          "text": "Chenopode blanc",
                          "value": "rec1nKcBZmxndYsZB"
                      }
                  ]
              },
              "perennials": {
                  "hideNone": true,
                  "sort": true,
                  "type": "checkbox",
                  "multiple": true,
                  "dependencies": {
                      "glyphosate": [
                          "VIVACES"
                      ]
                  },
                  "dataSource": [
                      {
                          "text": "Ray-grass",
                          "value": "recjzIBqwGkton9Ed"
                      },
                      {
                          "text": "Chardon des champs",
                          "value": "recZkVZESGvUlCtNi"
                      },
                      {
                          "text": "Liseron",
                          "value": "recBD6n3k77eFRHES"
                      },
                      {
                          "text": "Rumex",
                          "value": "rec2wnpJOAJzUFe5v"
                      }
                  ]
              },
              "glyphosate": {
                  "hideNone": true,
                  "sort": false,
                  "type": "radio",
                  "multiple": false,
                  "dependencies": {
                      "problem": "GLYPHOSATE"
                  },
                  "dataSource": [
                      {
                          "text": "Gestion de vivaces",
                          "value": "VIVACES"
                      },
                      {
                          "text": "Destruction des couverts",
                          "value": "COUVERTS"
                      },
                      {
                          "text": "Nettoyage des parcelles reverdies",
                          "value": "PARCELLES"
                      },
                      {
                          "text": "Destruction des prairies",
                          "value": "PRAIRIES"
                      },
                      {
                          "text": "Autre",
                          "value": "AUTRES"
                      }
                  ]
              },
              "practices": {
                  "hideNone": true,
                  "sort": true,
                  "type": "checkbox",
                  "multiple": true,
                  "dataSource": [
                      {
                          "text": "Allongement de la rotation",
                          "value": "ALLONGEMENT_ROTATION"
                      },
                      {
                          "text": "Alterner cultures de printemps et automne",
                          "value": "ALTERNER_PRINTEMPS_AUTOMNE"
                      },
                      {
                          "text": "Application de produits de biocontrôle",
                          "value": "PRODUIT_BIOCONTROLE"
                      },
                      {
                          "text": "Couverts végétaux",
                          "value": "COUVERTS_VEGETAUX"
                      },
                      {
                          "text": "Décalage de la date de semis",
                          "value": "DATE_SEMIS"
                      },
                      {
                          "text": "Désherbage mécanique",
                          "value": "DESHERBAGE_MECANIQUE"
                      },
                      {
                          "text": "Destruction mécanique de couvert",
                          "value": "DESTRUCTION_COUVERT"
                      },
                      {
                          "text": "Faux semis",
                          "value": "FAUX_SEMIS"
                      },
                      {
                          "text": "Infrastructures Agro-écologique",
                          "value": "INFRASTRUCTURE"
                      },
                      {
                          "text": "Insectes auxiliaires",
                          "value": "INSECTES_AUXILIAIRES"
                      },
                      {
                          "text": "Introduction d\'une variété résistante",
                          "value": "VARIETE_RESISTANTE"
                      },
                      {
                          "text": "Introduction des nouvelles cultures dans la rotation",
                          "value": "NOUVELLES_CULTURES"
                      },
                      {
                          "text": "Mélange de varietés",
                          "value": "MELANGE_VARIETES"
                      },
                      {
                          "text": "Optimisation des doses",
                          "value": "REDUCTION_DOSES"
                      },
                      {
                          "text": "Outil d\'aide à la décision",
                          "value": "OAD"
                      },
                      {
                          "text": "Plantes compagnes",
                          "value": "PLANTES_COMPAGNES"
                      },
                      {
                          "text": "Plantes de service",
                          "value": "PLANTES_DE_SERVICE"
                      },
                      {
                          "text": "Prophylaxie",
                          "value": "PROPHYLAXIE"
                      },
                      {
                          "text": "Semis direct",
                          "value": "SEMIS_DIRECT"
                      },
                      {
                          "text": "Service de l\'élevage",
                          "value": "ELEVAGE"
                      },
                      {
                          "text": "Travail profond",
                          "value": "TRAVAIL_PROFOND"
                      },
                      {
                          "text": "Travail superficiel du sol",
                          "value": "TRAVAIL_DU_SOL"
                      }
                  ]
              },
              "tillage": {
                  "hideNone": true,
                  "sort": false,
                  "type": "radio",
                  "multiple": true,
                  "dataSource": [
                      {
                          "text": "Tous types de travail du sol",
                          "value": "TRAVAIL_PROFOND"
                      },
                      {
                          "text": "Travail superficiel uniquement",
                          "value": "TRAVAIL_DU_SOL"
                      },
                      {
                          "text": "Aucun travail du sol",
                          "value": "NONE"
                      }
                  ]
              },
              "cattle": {
                  "sort": false,
                  "hideNone": true,
                  "type": "radio"
              },
              "rotation": {
                  "type": "array",
                  "toolbarSticky": true,
                  "items": {
                      "type": "select",
                      "dataSource": [
                          {
                              "text": "Féveroles d\'automne",
                              "value": "rectAd8Qjo4elTNzw"
                          },
                          {
                              "text": "Féveroles de printemps",
                              "value": "recheRcN1QkPsDxjz"
                          },
                          {
                              "text": "Légumes d\'industries",
                              "value": "recoTdPByBTXD6nFy"
                          },
                          {
                              "text": "Lentille",
                              "value": "rec3MMGtn1Yd8KRnx"
                          },
                          {
                              "text": "Lin hiver",
                              "value": "rec9Q8362B8M2lvEI"
                          },
                          {
                              "text": "Lin printemps",
                              "value": "rec5t8AmLBoCuKHMF"
                          },
                          {
                              "text": "Pomme de terre",
                              "value": "recURJ9JQS9u6OHva"
                          },
                          {
                              "text": "Avoine",
                              "value": "rec9tcAjFQI1txXpw"
                          },
                          {
                              "text": "Betterave",
                              "value": "recKDNdfSiV33djzf"
                          },
                          {
                              "text": "Blé dur",
                              "value": "recuVebqXEqCg8kK0"
                          },
                          {
                              "text": "Blé tendre d\'hiver",
                              "value": "recmm8lo1bGXCYSA3"
                          },
                          {
                              "text": "Blé tendre de printemps",
                              "value": "recSmDBTPyv0R1Rik"
                          },
                          {
                              "text": "Chanvre",
                              "value": "recvopi6FLS3gJL7S"
                          },
                          {
                              "text": "Colza",
                              "value": "recZj4cTO0dwcYhbe"
                          },
                          {
                              "text": "Luzerne",
                              "value": "recxgdYdorhQL8ISG"
                          },
                          {
                              "text": "Maïs",
                              "value": "recsPtaEneeYVoEWx"
                          },
                          {
                              "text": "Orge",
                              "value": "recfGVtMZSz05Rfl8"
                          },
                          {
                              "text": "Orge de printemps",
                              "value": "recEEz6LZ3MRDdV99"
                          },
                          {
                              "text": "Plantes médicinales",
                              "value": "rec3V9kcadPnA2uOf"
                          },
                          {
                              "text": "Pois",
                              "value": "recs8TxZArv0xOWzu"
                          },
                          {
                              "text": "Prairies et cultures fourragères",
                              "value": "recO2AS9ndt3GwP2A"
                          },
                          {
                              "text": "Sarrasin",
                              "value": "recDj6iPO41gku4rK"
                          },
                          {
                              "text": "Soja",
                              "value": "recwHs4aAiZc9okg9"
                          },
                          {
                              "text": "Tournesol",
                              "value": "rec5MHmc9xIgAg8ha"
                          },
                          {
                              "text": "Triticale",
                              "value": "recf5szern0AltHXC"
                          },
                          {
                              "text": "Vigne",
                              "value": "recT3CrK0EqgCGL8z"
                          }
                      ]
                  },
                  "toolbar": {
                      "actions": [
                          {
                              "label": "Ajoutez une culture",
                              "action": "add"
                          }
                      ]
                  },
                  "actionbar": {
                      "actions": [
                          {
                              "action": "up",
                              "enabled": false
                          },
                          {
                              "action": "down",
                              "enabled": false
                          }
                      ]
                  }
              },
              "department": {
                  "type": "select",
                  "dataSource": [
                      {
                          "value": "01",
                          "text": "01 - Ain"
                      },
                      {
                          "value": "02",
                          "text": "02 - Aisne"
                      },
                      {
                          "value": "03",
                          "text": "03 - Allier"
                      },
                      {
                          "value": "04",
                          "text": "04 - Alpes-de-Haute-Provence"
                      },
                      {
                          "value": "05",
                          "text": "05 - Hautes-alpes"
                      },
                      {
                          "value": "06",
                          "text": "06 - Alpes-maritimes"
                      },
                      {
                          "value": "07",
                          "text": "07 - Ardèche"
                      },
                      {
                          "value": "08",
                          "text": "08 - Ardennes"
                      },
                      {
                          "value": "09",
                          "text": "09 - Ariège"
                      },
                      {
                          "value": "10",
                          "text": "10 - Aube"
                      },
                      {
                          "value": "11",
                          "text": "11 - Aude"
                      },
                      {
                          "value": "12",
                          "text": "12 - Aveyron"
                      },
                      {
                          "value": "13",
                          "text": "13 - Bouches-du-Rhône"
                      },
                      {
                          "value": "14",
                          "text": "14 - Calvados"
                      },
                      {
                          "value": "15",
                          "text": "15 - Cantal"
                      },
                      {
                          "value": "16",
                          "text": "16 - Charente"
                      },
                      {
                          "value": "17",
                          "text": "17 - Charente-maritime"
                      },
                      {
                          "value": "18",
                          "text": "18 - Cher"
                      },
                      {
                          "value": "19",
                          "text": "19 - Corrèze"
                      },
                      {
                          "value": "2a",
                          "text": "2a - Corse-du-sud"
                      },
                      {
                          "value": "2b",
                          "text": "2b - Haute-Corse"
                      },
                      {
                          "value": "21",
                          "text": "21 - Côte-d\'Or"
                      },
                      {
                          "value": "22",
                          "text": "22 - Côtes-d\'Armor"
                      },
                      {
                          "value": "23",
                          "text": "23 - Creuse"
                      },
                      {
                          "value": "24",
                          "text": "24 - Dordogne"
                      },
                      {
                          "value": "25",
                          "text": "25 - Doubs"
                      },
                      {
                          "value": "26",
                          "text": "26 - Drôme"
                      },
                      {
                          "value": "27",
                          "text": "27 - Eure"
                      },
                      {
                          "value": "28",
                          "text": "28 - Eure-et-loir"
                      },
                      {
                          "value": "29",
                          "text": "29 - Finistère"
                      },
                      {
                          "value": "30",
                          "text": "30 - Gard"
                      },
                      {
                          "value": "31",
                          "text": "31 - Haute-garonne"
                      },
                      {
                          "value": "32",
                          "text": "32 - Gers"
                      },
                      {
                          "value": "33",
                          "text": "33 - Gironde"
                      },
                      {
                          "value": "34",
                          "text": "34 - Hérault"
                      },
                      {
                          "value": "35",
                          "text": "35 - Ille-et-vilaine"
                      },
                      {
                          "value": "36",
                          "text": "36 - Indre"
                      },
                      {
                          "value": "37",
                          "text": "37 - Indre-et-loire"
                      },
                      {
                          "value": "38",
                          "text": "38 - Isère"
                      },
                      {
                          "value": "39",
                          "text": "39 - Jura"
                      },
                      {
                          "value": "40",
                          "text": "40 - Landes"
                      },
                      {
                          "value": "41",
                          "text": "41 - Loir-et-cher"
                      },
                      {
                          "value": "42",
                          "text": "42 - Loire"
                      },
                      {
                          "value": "43",
                          "text": "43 - Haute-loire"
                      },
                      {
                          "value": "44",
                          "text": "44 - Loire-atlantique"
                      },
                      {
                          "value": "45",
                          "text": "45 - Loiret"
                      },
                      {
                          "value": "46",
                          "text": "46 - Lot"
                      },
                      {
                          "value": "47",
                          "text": "47 - Lot-et-garonne"
                      },
                      {
                          "value": "48",
                          "text": "48 - Lozère"
                      },
                      {
                          "value": "49",
                          "text": "49 - Maine-et-loire"
                      },
                      {
                          "value": "50",
                          "text": "50 - Manche"
                      },
                      {
                          "value": "51",
                          "text": "51 - Marne"
                      },
                      {
                          "value": "52",
                          "text": "52 - Haute-marne"
                      },
                      {
                          "value": "53",
                          "text": "53 - Mayenne"
                      },
                      {
                          "value": "54",
                          "text": "54 - Meurthe-et-moselle"
                      },
                      {
                          "value": "55",
                          "text": "55 - Meuse"
                      },
                      {
                          "value": "56",
                          "text": "56 - Morbihan"
                      },
                      {
                          "value": "57",
                          "text": "57 - Moselle"
                      },
                      {
                          "value": "58",
                          "text": "58 - Nièvre"
                      },
                      {
                          "value": "59",
                          "text": "59 - Nord"
                      },
                      {
                          "value": "60",
                          "text": "60 - Oise"
                      },
                      {
                          "value": "61",
                          "text": "61 - Orne"
                      },
                      {
                          "value": "62",
                          "text": "62 - Pas-de-calais"
                      },
                      {
                          "value": "63",
                          "text": "63 - Puy-de-dôme"
                      },
                      {
                          "value": "64",
                          "text": "64 - Pyrénées-atlantiques"
                      },
                      {
                          "value": "65",
                          "text": "65 - Hautes-Pyrénées"
                      },
                      {
                          "value": "66",
                          "text": "66 - Pyrénées-orientales"
                      },
                      {
                          "value": "67",
                          "text": "67 - Bas-rhin"
                      },
                      {
                          "value": "68",
                          "text": "68 - Haut-rhin"
                      },
                      {
                          "value": "69",
                          "text": "69 - Rhône"
                      },
                      {
                          "value": "70",
                          "text": "70 - Haute-saône"
                      },
                      {
                          "value": "71",
                          "text": "71 - Saône-et-loire"
                      },
                      {
                          "value": "72",
                          "text": "72 - Sarthe"
                      },
                      {
                          "value": "73",
                          "text": "73 - Savoie"
                      },
                      {
                          "value": "74",
                          "text": "74 - Haute-savoie"
                      },
                      {
                          "value": "75",
                          "text": "75 - Paris"
                      },
                      {
                          "value": "76",
                          "text": "76 - Seine-maritime"
                      },
                      {
                          "value": "77",
                          "text": "77 - Seine-et-marne"
                      },
                      {
                          "value": "78",
                          "text": "78 - Yvelines"
                      },
                      {
                          "value": "79",
                          "text": "79 - Deux-sèvres"
                      },
                      {
                          "value": "80",
                          "text": "80 - Somme"
                      },
                      {
                          "value": "81",
                          "text": "81 - Tarn"
                      },
                      {
                          "value": "82",
                          "text": "82 - Tarn-et-garonne"
                      },
                      {
                          "value": "83",
                          "text": "83 - Var"
                      },
                      {
                          "value": "84",
                          "text": "84 - Vaucluse"
                      },
                      {
                          "value": "85",
                          "text": "85 - Vendée"
                      },
                      {
                          "value": "86",
                          "text": "86 - Vienne"
                      },
                      {
                          "value": "87",
                          "text": "87 - Haute-vienne"
                      },
                      {
                          "value": "88",
                          "text": "88 - Vosges"
                      },
                      {
                          "value": "89",
                          "text": "89 - Yonne"
                      },
                      {
                          "value": "90",
                          "text": "90 - Territoire de belfort"
                      },
                      {
                          "value": "91",
                          "text": "91 - Essonne"
                      },
                      {
                          "value": "92",
                          "text": "92 - Hauts-de-seine"
                      },
                      {
                          "value": "93",
                          "text": "93 - Seine-Saint-Denis"
                      },
                      {
                          "value": "94",
                          "text": "94 - Val-de-marne"
                      },
                      {
                          "value": "95",
                          "text": "95 - Val-d\'oise"
                      },
                      {
                          "value": "971",
                          "text": "971 - Guadeloupe"
                      },
                      {
                          "value": "972",
                          "text": "972 - Martinique"
                      },
                      {
                          "value": "973",
                          "text": "973 - Guyane"
                      },
                      {
                          "value": "974",
                          "text": "974 - La réunion"
                      },
                      {
                          "value": "976",
                          "text": "976 - Mayotte"
                      }
                  ]
              },
              "groups": {
                  "hideNone": true,
                  "sort": false,
                  "type": "checkbox",
                  "multiple": true,
                  "dataSource": [
                      {
                          "text": "DEPHY",
                          "value": "groupe_DEPHY"
                      },
                      {
                          "text": "30000",
                          "value": "groupe_30000"
                      },
                      {
                          "text": "GIEE",
                          "value": "groupe_GIEE"
                      },
                      {
                          "text": "Groupe de chambre d\'agriculture",
                          "value": "groupe_chambre_agriculture"
                      },
                      {
                          "text": "Groupe de coopérative ou négoce",
                          "value": "groupe_cooperative_negoce"
                      },
                      {
                          "text": "Je suis en AB ou en conversion AB",
                          "value": "groupe_conversion_ab"
                      },
                      {
                          "text": "Autre",
                          "value": "groupe_autre"
                      },
                      {
                          "text": "Aucun",
                          "value": "groupe_aucun"
                      }
                  ]
              },
              "referer": {
                  "hideNone": true,
                  "sort": false,
                  "type": "checkbox",
                  "multiple": true,
                  "dataSource": [
                      {
                          "text": "Moteur de recherche (Google, Bing, etc.)",
                          "value": "referer_moteur_recherche"
                      },
                      {
                          "text": "Réseaux sociaux (Facebook, Twitter)",
                          "value": "referer_reseaux_sociaux"
                      },
                      {
                          "text": "Bouche à oreille",
                          "value": "referer_bouche_a_oreille"
                      },
                      {
                          "text": "Presse",
                          "value": "referer_presse"
                      },
                      {
                          "text": "Par ma coopérative ou mon négoce",
                          "value": "referer_cooperative_negoce"
                      },
                      {
                          "text": "Par ma Chambre d\'Agriculture",
                          "value": "referer_chambre_agriculture"
                      },
                      {
                          "text": "Par un agriculteur",
                          "value": "referer_agriculteur"
                      },
                      {
                          "text": "Via un atelier sur mon territoire",
                          "value": "referer_aterlier"
                      },
                      {
                          "text": "Par la DDT",
                          "value": "referer_ddt"
                      },
                      {
                          "text": "Autre",
                          "value": "referer_autre"
                      }
                  ]
              }
          }
      }
  }
  """;
}
