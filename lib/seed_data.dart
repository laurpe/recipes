import 'package:recipes/recipe.dart';

const seedRecipes = [
  Recipe(
      name: "Pannukakku",
      instructions:
          "Vatkaa munat. Lisää maito ja jauhot. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "kananmunaa", amount: "4", unit: "kpl"),
        Ingredient(name: "maitoa", amount: "1", unit: "l"),
        Ingredient(name: "vehnäjauhoja", amount: "2", unit: "dl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Mustikkapiirakka",
      instructions:
          "Sekoita kuivat aineet. Lisää rasva ja sekoita. Lisää maito ja sekoita. Lisää mustikat. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "kananmunaa", amount: "1", unit: "kpl"),
        Ingredient(name: "sokeria", amount: "1", unit: "dl"),
        Ingredient(name: "vaniljasokeria", amount: "1", unit: "tl"),
        Ingredient(name: "leivinjauhetta", amount: "1", unit: "tl"),
        Ingredient(name: "vehnäjauhoja", amount: "3", unit: "dl"),
        Ingredient(name: "maitoa", amount: "1", unit: "dl"),
        Ingredient(name: "voita", amount: "75", unit: "g"),
        Ingredient(name: "mustikoita", amount: "2", unit: "dl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Kasvissosekeitto",
      instructions:
          "Kuori ja pilko kasvikset. Keitä kasvikset kypsiksi. Soseuta sauvasekoittimella. Lisää vesi ja mausteet. Kuumenna.",
      ingredients: [
        Ingredient(name: "perunaa", amount: "4", unit: "kpl"),
        Ingredient(name: "porkkanaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Makaronilaatikko",
      instructions:
          "Keitä makaronit. Sekoita kaikki ainekset. Paista 200 asteessa 45 minuuttia.",
      ingredients: [
        Ingredient(name: "makaronia", amount: "5", unit: "dl"),
        Ingredient(name: "soijarouhetta", amount: "2", unit: "dl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "kananmunaa", amount: "2", unit: "kpl"),
        Ingredient(name: "maitoa", amount: "5", unit: "dl"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Linssikeitto",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja linssit. Keitä 20 minuuttia. Lisää mausteet. Soseuta sauvasekoittimella.",
      ingredients: [
        Ingredient(name: "linssejä", amount: "2", unit: "dl"),
        Ingredient(name: "porkkanaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "valkosipulinkynttä", amount: "2", unit: "kpl"),
        Ingredient(name: "öljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Soijarouhekastike",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää soijarouhe ja vesi. Keitä 10 minuuttia. Lisää mausteet. Tarjoile pastan kanssa.",
      ingredients: [
        Ingredient(name: "soijarouhetta", amount: "2", unit: "dl"),
        Ingredient(name: "porkkanaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "valkosipulinkynttä", amount: "2", unit: "kpl"),
        Ingredient(name: "öljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Kasvispihvit",
      instructions:
          "Kuori ja pilko kasvikset. Sekoita kaikki ainekset. Paista pihveiksi pannulla.",
      ingredients: [
        Ingredient(name: "soijarouhetta", amount: "2", unit: "dl"),
        Ingredient(name: "porkkanaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "valkosipulinkynttä", amount: "2", unit: "kpl"),
        Ingredient(name: "öljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Kasvislasagne",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja mausteet. Keitä 20 minuuttia. Lisää tomaattimurska. Kuumenna. Lado vuokaan kerroksittain kasviskastiketta, lasagnelevyjä ja juustokastiketta. Paista 200 asteessa 45 minuuttia.",
      ingredients: [
        Ingredient(name: "porkkanaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "valkosipulinkynttä", amount: "2", unit: "kpl"),
        Ingredient(name: "öljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl"),
        Ingredient(name: "tomaattimurskaa", amount: "1", unit: "prk"),
        Ingredient(name: "lasagnelevyjä", amount: "1", unit: "pkt"),
        Ingredient(name: "juustokastiketta", amount: "2", unit: "dl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Sämpylät",
      instructions:
          "Sekoita kuivat aineet. Lisää maito ja sekoita. Pyörittele sämpylöiksi. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "vehnäjauhoja", amount: "5", unit: "dl"),
        Ingredient(name: "hiivaa", amount: "1", unit: "pss"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "maitoa", amount: "2", unit: "dl")
      ],
      favorite: false,
      servings: 16),
  Recipe(
      name: "Pokebowl",
      instructions:
          "Keitä riisi. Kuori ja pilko kasvikset. Sekoita kastikkeen ainekset. Aseta kulhoon riisi, kasvikset ja kastike. Tarjoile.",
      ingredients: [
        Ingredient(name: "riisiä", amount: "2", unit: "dl"),
        Ingredient(name: "kurkkua", amount: "1", unit: "kpl"),
        Ingredient(name: "porkkanaa", amount: "1", unit: "kpl"),
        Ingredient(name: "avokadoa", amount: "1", unit: "kpl"),
        Ingredient(name: "tomaattia", amount: "1", unit: "kpl"),
        Ingredient(name: "korianteria", amount: "1", unit: "kpl"),
        Ingredient(name: "soijakastiketta", amount: "1", unit: "rkl"),
        Ingredient(name: "limettimehua", amount: "1", unit: "rkl"),
        Ingredient(name: "inkivääriä", amount: "1", unit: "tl"),
        Ingredient(name: "valkosipulinkynttä", amount: "1", unit: "kpl"),
        Ingredient(name: "chiliä", amount: "1", unit: "kpl"),
        Ingredient(name: "oliiviöljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Maa-artisokkakeitto",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja mausteet. Keitä 20 minuuttia. Soseuta sauvasekoittimella.",
      ingredients: [
        Ingredient(name: "maa-artisokkaa", amount: "2", unit: "kpl"),
        Ingredient(name: "perunaa", amount: "2", unit: "kpl"),
        Ingredient(name: "sipulia", amount: "1", unit: "kpl"),
        Ingredient(name: "valkosipulinkynttä", amount: "2", unit: "kpl"),
        Ingredient(name: "öljyä", amount: "1", unit: "rkl"),
        Ingredient(name: "vettä", amount: "1", unit: "l"),
        Ingredient(name: "suolaa", amount: "1", unit: "tl"),
        Ingredient(name: "mustapippuria", amount: "1", unit: "tl")
      ],
      favorite: false,
      servings: 4),
];

const seedTags = ['breakfast', 'lunch', 'dinner', 'dessert', 'snack'];
