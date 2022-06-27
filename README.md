# Programacion Avanzada Trabajo Final Juego de Cartas (CALERA)

## Diagrama de Clases

![Diagrama Clases](https://github.com/tomas1646/Juego-de-Cartas-Rails-Backend/blob/master/Diagrama%20Clases.jpeg?raw=true)

## Endpoints

### Player

| Metodo | Ruta                    | Accion                                                   |
| ------ | ----------------------- | -------------------------------------------------------- |
| POST   | /players                | [Registrar Usuario](#post-players)                       |
| PUT    | /players                | [Actualizar Usuario](#put-players)                       |
| POST   | /players/login          | [Login](#post-playerslogin)                              |
| PUT    | /players/update_picture | [Actualizar foto del usuario](#put-playersupdatepicture) |

### Board

| Metodo | Ruta                   | Accion                                                        |
| ------ | ---------------------- | ------------------------------------------------------------- |
| GET    | /boards                | [Obtener los tableros](#get-boards)                           |
| GET    | /boards/:id            | [Obtener un tablero](#get-boardsid)                           |
| POST   | /boards                | [Crear un tablero](#post-boards)                              |
| POST   | /boards/:id/join       | [Unirse a un tablero](#post-boardsidjoin)                     |
| POST   | /boards/:id/start_game | [Empezar la partida](#post-boardsidstartgame)                 |
| POST   | /boards/:id/bet_wins   | [Rondas que va a ganar cada jugador](#post-boardsidthrowcard) |
| POST   | /boards/:id/throw_card | [Tirar una carta](#post-boardsidthrowcard)                    |
| GET    | /boards/:id/cards      | [Obtener las cartas de un jugador](#get-boardsidcards)        |

---

## Descripción de los Endpoints

### Player Endpoints

---

#### POST /players

Registrar Jugador

REQUEST

```json
{
  "name": "Tomas E",
  "user_name": "tomas1646",
  "password": "password"
}
```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Player Created",
  "content": {
    "name": "Tomas E",
    "user_name": "tomas1646",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "avatar_url": ""
  }
}
```

Error:

```json
{
  "status": 400,
  "message": "Error creating Player",
  "content": {}
}
```

---

#### POST /players/login

Login

REQUEST

```json
{
  "user_name": "tomas1646",
  "password": "password"
}
```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Login successful",
  "content": {
    "name": "Tomas E",
    "user_name": "tomas1646",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "avatar_url": ""
  }
}
```

Error:

```json
{
  "status": 400,
  "message": "Incorrect Username or Password",
  "content": {}
}
```

---

#### PUT /players

Actualizar los datos del jugador logueado

REQUEST

```text
Request.Authorization = Player Token
```

```json
{
  "name": "Tomas E",
  "user_name": "tomas1646",
  "password": "password"
}
```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Player Updated",
  "content": {
    "name": "Tomas E",
    "user_name": "tomas1646",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "avatar_url": ""
  }
}
```

Error:

```json
{
  "status": 400,
  "message": "Error updating Player",
  "content": {}
}
```

---

#### PUT /players/update_picture

Actualizar la foto del jugador logueado

REQUEST

```text
Request.Authorization = Player Token
Request.Content-Type: multipart/form-data
```

Request Content

```text
{
  "avatar": Image
}

```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Picture Updated",
  "content": {
    "name": "Tomas E",
    "user_name": "tomas1646",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "avatar_url": "/rails/..../picture.png"
  }
}
```

Error:

```json
{
  "status": 400,
  "message": "Error updating Picture",
  "content": {}
}
```

---

### Board Endpoints

---

#### GET /boards

Obtener todos los boards. Se puede filtrar, que busque Boards por estado y/o por el jugador logueado

```text
Si queremos filtrar por los boards en los que esta el usuario logueado, la url se debe agregar
...?player=true

Si queremos filtrar por estado, en la url se debe agregar el numero correspondiente al estado
...?status[]=1&status[]=2
```

REQUEST

```text
Request.Authorization = Player Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Action completed successfully",
  "content": [
    {
      "status": "in_course",
      "board_players": [
        {
          "player_id": 1,
          "status": "...",
          "score": "...."
        },
        {
          "player_id": 2,
          "status": "...",
          "score": "..."
        }
      ],
      "last_round": {
        "number_of_cards": 5,
        "round_number": 2,
        "status": "finished",
        "round_players": [
          {
            "player_id": 1,
            "bet_wins": 1,
            "current_wins": 3,
            "bet_position": 0
          },
          {
            "player_id": 2,
            "bet_wins": 0,
            "current_wins": 2,
            "bet_position": 1
          }
        ],
        "games": [
          {
            "game_number": 0,
            "winner_id": 1,
            "status": "finished"
          },
          {
            "game_number": 1,
            "winner_id": null,
            "status": "in_course"
          }
        ]
      }
    }
  ]
}
```

---

#### GET /boards/:id

Obtener un board en especifico

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Action completed successfully",
  "content": {
    "status": "in_course",
    "board_players": [
      {
        "player_id": 1,
        "status": "...",
        "score": "...."
      },
      {
        "player_id": 2,
        "status": "...",
        "score": "..."
      }
    ],
    "last_round": {
      "number_of_cards": 5,
      "round_number": 2,
      "status": "finished",
      "round_players": [
        {
          "player_id": 1,
          "bet_wins": 1,
          "current_wins": 3,
          "bet_position": 0
        },
        {
          "player_id": 2,
          "bet_wins": 0,
          "current_wins": 2,
          "bet_position": 1
        }
      ],
      "games": [
        {
          "game_number": 0,
          "winner_id": 1,
          "status": "finished"
        },
        {
          "game_number": 1,
          "winner_id": null,
          "status": "in_course"
        }
      ]
    }
  }
}
```

Error:

```json
{
  "status": 404,
  "success": false,
  "message": "Board doesn't exists",
  "content": {}
}
```

---

#### POST /boards

Crear un tablero

REQUEST

```text
Request.Authorization = Player Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Board Created",
  "content": {
    "status": "waiting_players",
    "board_players": [
      {
        "player_id": 1,
        "status": null,
        "score": ""
      }
    ]
  }
}
```

---

#### POST /boards/:id/join

El jugador logueado se une al board

REQUEST

```text
Request.Authorization = Player Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Joined to the board",
  "content": {
    "status": "waiting_players",
    "board_players": [
      {
        "player_id": 1,
        "status": null,
        "score": ""
      },
      {
        "player_id": 2,
        "status": null,
        "score": ""
      }
    ]
  }
}
```

---

#### POST /boards/:id/start_game

Empezar la partida

REQUEST

```text
Request.Authorization = Player Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Game Started",
  "content": {
    "status": "in_course",
    "board_players": [
      {
        "player_id": 1,
        "status": null,
        "score": ""
      },
      {
        "player_id": 2,
        "status": null,
        "score": ""
      }
    ],
    "last_round": {
      "number_of_cards": 3,
      "round_number": 0,
      "status": "waiting_bet_asked",
      "round_players": [
        {
          "player_id": 1,
          "bet_wins": null,
          "current_wins": 0,
          "bet_position": 0
        },
        {
          "player_id": 2,
          "bet_wins": null,
          "current_wins": 0,
          "bet_position": 1
        }
      ],
      "games": []
    }
  }
}
```

---

#### POST /boards/:id/bet_wins

El jugador logueado apuesta cuantas rondas va a ganar

REQUEST

```text
Request.Authorization = Player Token
```

```json
{
  "wins": 2
}
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Win Number Set",
  "content": {
    "status": "in_course",
    "board_players": [
      {
        "player_id": 1,
        "status": null,
        "score": ""
      },
      {
        "player_id": 2,
        "status": null,
        "score": ""
      }
    ],
    "last_round": {
      "number_of_cards": 3,
      "round_number": 0,
      "status": "waiting_bet_asked",
      "round_players": [
        {
          "player_id": 2,
          "bet_wins": null,
          "current_wins": 0,
          "bet_position": 1
        },
        {
          "player_id": 1,
          "bet_wins": 2,
          "current_wins": 0,
          "bet_position": 0
        }
      ],
      "games": []
    }
  }
}
```

---

#### POST /boards/:id/throw_card

Tirar una carta

REQUEST

```text
Request.Authorization = Player Token
```

```json
{
  "card": "12-Or"
}
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Card Thrown",
  "content": {
    "status": "in_course",
    "board_players": [
      {
        "player_id": 1,
        "status": null,
        "score": ""
      },
      {
        "player_id": 2,
        "status": null,
        "score": ""
      }
    ],
    "last_round": {
      "number_of_cards": 3,
      "round_number": 0,
      "status": "waiting_card_throw",
      "round_players": [
        {
          "player_id": 2,
          "bet_wins": 1,
          "current_wins": 0,
          "bet_position": 1
        },
        {
          "player_id": 1,
          "bet_wins": 1,
          "current_wins": 0,
          "bet_position": 0
        }
      ],
      "games": [
        {
          "game_number": 0,
          "winner_id": null,
          "status": "in_course"
        }
      ]
    }
  }
}
```

---

#### GET /boards/:id/cards

Obtener las cartas del jugador logueado

REQUEST

```text
Request.Authorization = Player Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "success": true,
  "message": "Action completed successfully",
  "content": ["10-Or", "4-Or", "10-Co"]
}
```

---
