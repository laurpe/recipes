import 'package:recipes/recipe.dart';

const seedRecipes = [
  Recipe(
      name: "Pannukakku",
      instructions:
          "Vatkaa munat. Lisää maito ja jauhot. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "kananmunaa", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "maitoa", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "vehnäjauhoja", amountPerServing: 0.5, unit: "dl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Mustikkapiirakka",
      instructions:
          "Sekoita kuivat aineet. Lisää rasva ja sekoita. Lisää maito ja sekoita. Lisää mustikat. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "kananmunaa", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "sokeria", amountPerServing: 0.25, unit: "dl"),
        Ingredient(name: "vaniljasokeria", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "leivinjauhetta", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "vehnäjauhoja", amountPerServing: 1, unit: "dl"),
        Ingredient(name: "maitoa", amountPerServing: 0.25, unit: "dl"),
        Ingredient(name: "voita", amountPerServing: 0.25, unit: "g"),
        Ingredient(name: "mustikoita", amountPerServing: 0.5, unit: "dl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Kasvissosekeitto",
      instructions:
          "Kuori ja pilko kasvikset. Keitä kasvikset kypsiksi. Soseuta sauvasekoittimella. Lisää vesi ja mausteet. Kuumenna.",
      ingredients: [
        Ingredient(name: "perunaa", amountPerServing: 1, unit: "kpl"),
        Ingredient(name: "porkkanaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Makaronilaatikko",
      instructions:
          "Keitä makaronit. Sekoita kaikki ainekset. Paista 200 asteessa 45 minuuttia.",
      ingredients: [
        Ingredient(name: "makaronia", amountPerServing: 1, unit: "dl"),
        Ingredient(name: "soijarouhetta", amountPerServing: 0.5, unit: "dl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "kananmunaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "maitoa", amountPerServing: 1, unit: "dl"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Linssikeitto",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja linssit. Keitä 20 minuuttia. Lisää mausteet. Soseuta sauvasekoittimella.",
      ingredients: [
        Ingredient(name: "linssejä", amountPerServing: 0.5, unit: "dl"),
        Ingredient(name: "porkkanaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "öljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Soijarouhekastike",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää soijarouhe ja vesi. Keitä 10 minuuttia. Lisää mausteet. Tarjoile pastan kanssa.",
      ingredients: [
        Ingredient(name: "soijarouhetta", amountPerServing: 0.5, unit: "dl"),
        Ingredient(name: "porkkanaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "öljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Kasvispihvit",
      instructions:
          "Kuori ja pilko kasvikset. Sekoita kaikki ainekset. Paista pihveiksi pannulla.",
      ingredients: [
        Ingredient(name: "soijarouhetta", amountPerServing: 0.5, unit: "dl"),
        Ingredient(name: "porkkanaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "öljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Kasvislasagne",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja mausteet. Keitä 20 minuuttia. Lisää tomaattimurska. Kuumenna. Lado vuokaan kerroksittain kasviskastiketta, lasagnelevyjä ja juustokastiketta. Paista 200 asteessa 45 minuuttia.",
      ingredients: [
        Ingredient(name: "porkkanaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "öljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl"),
        Ingredient(
            name: "tomaattimurskaa", amountPerServing: 0.25, unit: "prk"),
        Ingredient(name: "lasagnelevyjä", amountPerServing: 0.25, unit: "pkt"),
        Ingredient(name: "juustokastiketta", amountPerServing: 0.5, unit: "dl")
      ],
      favorite: false,
      servings: 8),
  Recipe(
      name: "Sämpylät",
      instructions:
          "Sekoita kuivat aineet. Lisää maito ja sekoita. Pyörittele sämpylöiksi. Paista 225 asteessa 20 minuuttia.",
      ingredients: [
        Ingredient(name: "vehnäjauhoja", amountPerServing: 1, unit: "dl"),
        Ingredient(name: "hiivaa", amountPerServing: 0.25, unit: "pss"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "maitoa", amountPerServing: 0.5, unit: "dl")
      ],
      favorite: false,
      servings: 16),
  Recipe(
      name: "Pokebowl",
      instructions:
          "Keitä riisi. Kuori ja pilko kasvikset. Sekoita kastikkeen ainekset. Aseta kulhoon riisi, kasvikset ja kastike. Tarjoile.",
      ingredients: [
        Ingredient(name: "riisiä", amountPerServing: 0.5, unit: "dl"),
        Ingredient(name: "kurkkua", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "porkkanaa", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "avokadoa", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "tomaattia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "korianteria", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "soijakastiketta", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "limettimehua", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "inkivääriä", amountPerServing: 0.25, unit: "tl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "chiliä", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(name: "oliiviöljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
  Recipe(
      name: "Maa-artisokkakeitto",
      instructions:
          "Kuori ja pilko kasvikset. Kuullota kasviksia öljyssä. Lisää vesi ja mausteet. Keitä 20 minuuttia. Soseuta sauvasekoittimella.",
      ingredients: [
        Ingredient(name: "maa-artisokkaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "perunaa", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "sipulia", amountPerServing: 0.25, unit: "kpl"),
        Ingredient(
            name: "valkosipulinkynttä", amountPerServing: 0.5, unit: "kpl"),
        Ingredient(name: "öljyä", amountPerServing: 0.25, unit: "rkl"),
        Ingredient(name: "vettä", amountPerServing: 0.25, unit: "l"),
        Ingredient(name: "suolaa", amountPerServing: 0.25, unit: "tl"),
        Ingredient(name: "mustapippuria", amountPerServing: 0.25, unit: "tl")
      ],
      favorite: false,
      servings: 4),
];

const seedTags = ['breakfast', 'lunch', 'dinner', 'dessert', 'snack'];
