db.players.findOne({nombre: "Patrick Mahomes"})

db.players.aggregate([
  {$group: {
    _id: "$posicion_grupo",
    total: {$sum: 1}
  }},
  {$sort: {total: -1}}
])

db.players.aggregate([
  {$match: {posicion_grupo: {$ne: null}}},
  {$group: {
    _id: "$draft.ronda",
    total_jugadores: {$sum: 1},
    w_av_promedio: {$avg: "$nfl_career.w_av"}
  }},
  {$sort: {_id: 1}}
])

db.players.aggregate([
  {$match: {
    posicion_grupo: {$ne: null},
    "nfl_career.w_av": {$ne: null}
  }},
  {$group: {
    _id: null,
    promedio: {$avg: "$nfl_career.w_av"},
    maximo: {$max: "$nfl_career.w_av"},
    minimo: {$min: "$nfl_career.w_av"},
    total: {$sum: 1}
  }}
])

db.players.aggregate([
  {$match: {
    posicion_grupo: {$ne: null},
    "nfl_career.w_av": {$ne: null}
  }},
  {$group: {
    _id: null,
    menos_de_10: {$sum: {$cond: [{$lt: ["$nfl_career.w_av", 10]}, 1, 0]}},
    mas_de_30: {$sum: {$cond: [{$gt: ["$nfl_career.w_av", 30]}, 1, 0]}},
    mas_de_60: {$sum: {$cond: [{$gt: ["$nfl_career.w_av", 60]}, 1, 0]}},
    total: {$sum: 1}
  }}
])

db.players.aggregate([
  {$match: {
    "nfl_career.w_av": {$ne: null},
    "nfl_career.probowls": {$ne: null}
  }},
  {$group: {
    _id: {
      $switch: {
        branches: [
          {case: {$lt: ["$nfl_career.w_av", 20]}, then: "1. Menos de 20"},
          {case: {$lt: ["$nfl_career.w_av", 40]}, then: "2. Entre 20 y 40"},
          {case: {$lt: ["$nfl_career.w_av", 60]}, then: "3. Entre 40 y 60"},
          {case: {$gte: ["$nfl_career.w_av", 60]}, then: "4. Mayor de 60"}
        ],
        default: "Sin clasificar"
      }
    },
    total_jugadores: {$sum: 1},
    promedio_probowls: {$avg: "$nfl_career.probowls"},
    con_probowl: {$sum: {$cond: [{$gt: ["$nfl_career.probowls", 0]}, 1, 0]}}
  }},
  {$sort: {_id: 1}}
])

db.players.aggregate([
  {$match: {posicion_grupo: {$ne: null}}},
  {$group: {
    _id: "$posicion_grupo",
    total: {$sum: 1},
    con_cuarenta: {$sum: {$cond: [{$ne: ["$combine.cuarenta", null]}, 1, 0]}},
    con_bench: {$sum: {$cond: [{$ne: ["$combine.bench", null]}, 1, 0]}},
    con_vertical: {$sum: {$cond: [{$ne: ["$combine.vertical", null]}, 1, 0]}},
    con_cone: {$sum: {$cond: [{$ne: ["$combine.cone", null]}, 1, 0]}}
  }},
  {$sort: {_id: 1}}
])

db.players.insertOne({
    "nombre": "Tom Brady",
    "posicion": "QB",
    "posicion_grupo": "QB",
    "universidad": "Michigan",
    "draft": {
        "temporada": 2000,
        "ronda": 6,
        "pick": 199,
        "equipo": "NWE"
    },
    "nfl_career": {
        "w_av": 184.0,
        "probowls": 15,
        "allpro": 3,
        "seasons_started": 21
    },
    "combine": {
        "cuarenta": 5.28,
        "bench": null,
        "vertical": 24.5,
        "broad_jump": 99.0,
        "cone": 7.2,
        "shuttle": 4.38,
        "altura_cm": 193.0,
        "peso_kg": 95.7
    },
    "college_stats": [
        {
            "temporada": 1996,
            "passing": {"ATT": 5, "COMPLETIONS": 3, "PCT": 0.600, "YDS": 26, "TD": 0, "INT": 1, "YPA": 5.2},
            "rushing": {"CAR": 0, "YDS": 0, "TD": 0, "YPC": 0.0}
        },
        {
            "temporada": 1997,
            "passing": {"ATT": 15, "COMPLETIONS": 12, "PCT": 0.800, "YDS": 103, "TD": 0, "INT": 0, "YPA": 6.9},
            "rushing": {"CAR": 2, "YDS": -14, "TD": 0, "YPC": -7.0}
        },
        {
            "temporada": 1998,
            "passing": {"ATT": 323, "COMPLETIONS": 200, "PCT": 0.619, "YDS": 2427, "TD": 14, "INT": 10, "YPA": 7.5},
            "rushing": {"CAR": 54, "YDS": -105, "TD": 2, "YPC": -1.9}
        },
        {
            "temporada": 1999,
            "passing": {"ATT": 295, "COMPLETIONS": 180, "PCT": 0.610, "YDS": 2217, "TD": 16, "INT": 6, "YPA": 7.5},
            "rushing": {"CAR": 34, "YDS": -31, "TD": 1, "YPC": -0.9}
        }
    ]
})

db.players.find(
    {
        "posicion_grupo": "QB",
        "nfl_career.w_av": {$gte: 50}
    },
    {
        "_id": 0,
        "nombre": 1,
        "draft.pick": 1,
        "draft.temporada": 1,
        "nfl_career.w_av": 1,
        "nfl_career.probowls": 1
    }
).sort({"nfl_career.w_av": -1}).limit(15)



db.players.aggregate([
  {$match: {
    "posicion_grupo": "QB",
    "draft.ronda": 1,
    "draft.temporada": {$lte: 2019},
    "nfl_career.w_av": {$ne: null}
  }},
  {$group: {
    _id: "$draft.temporada",
    w_av_promedio: {$avg: "$nfl_career.w_av"},
    jugadores: {$push: "$nombre"},
    total: {$sum: 1}
  }},
  {$sort: {_id: 1}}
])



db.players.aggregate([
  {$match: {
    "posicion_grupo": {$ne: null},
    "nfl_career.w_av": {$ne: null},
    "draft.temporada": {$lte: 2019}
  }},
  {$group: {
    _id: {
      temporada: "$draft.temporada",
      ronda: "$draft.ronda"
    },
    w_av_promedio: {$avg: "$nfl_career.w_av"},
    total: {$sum: 1}
  }},
  {$sort: {
    "_id.ronda": 1,
    "_id.temporada": 1
  }}
])


db.players.aggregate([
  {$match: {
    "posicion_grupo": {$ne: null},
    "nfl_career.w_av": {$ne: null},
    "draft.temporada": {$lte: 2019},
    "draft.pick": {$lte: 15}
  }},
  {$group: {
    _id: "$draft.temporada",
    w_av_promedio: {$avg: "$nfl_career.w_av"},
    total: {$sum: 1}
  }},
  {$sort: {_id: 1}}
])



db.players.find(
    {"draft_value.diferencial_wav": {$type: "number"},
     "draft_value.clasificacion": "unknown"},
    {"nombre": 1, "draft_value": 1}
).limit(5)


db.players.updateMany(
    {"draft_value.diferencial_wav": {$type: "number"},
     "draft_value.clasificacion": "unknown"},
    {$set: {
        "draft_value.diferencial_wav": null,
        "draft_value.w_av_perfecto": null
    }}
)


db.players.updateOne(
    {nombre: "Tom Brady"},
    {$unset: {"draft_value": ""}}
)



db.players.aggregate([
  {$match: {
    "draft_value.diferencial_wav": {$ne: null},
    "posicion_grupo": {$ne: null},
    "draft.temporada": {$lte: 2019}
  }},
  {$group: {
    _id: {
      temporada: "$draft.temporada",
      ronda: "$draft.ronda"
    },
    diferencial_promedio: {$avg: "$draft_value.diferencial_wav"},
    total: {$sum: 1}
  }},
  {$sort: {
    "_id.ronda": 1,
    "_id.temporada": 1
  }}
])



db.players.aggregate([
  {$match: {
    "nfl_career.w_av": {$ne: null},
    "posicion_grupo": {$ne: null}
  }},
  {$group: {
    _id: "$draft.equipo",
    w_av_promedio: {$avg: "$nfl_career.w_av"},
    total: {$sum: 1}
  }},
  {$sort: {w_av_promedio: -1}},
  {$limit: 32}
])
