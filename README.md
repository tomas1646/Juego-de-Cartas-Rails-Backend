# Programacion Avanzada TaTeTi

## Diagrama de Clases

![Diagrama Clases](https://github.com/tomas1646/Juego-de-Cartas-Rails-Backend/blob/master/Diagrama%20Clases.jpg?raw=true)

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

Obtener todos los tableros. Se puede filtrar por estado y por jugador

```text
Para obtener todos los tableros: ".../boards"

Para obtener todos los con un estado en especifico: ".../boards?status[]=0"

Para obtener todos los tableros de un usuario: ".../boards?user"
```

Ejemplo si queremos obtener todos los tableros en los que esta el usuario logueado, y que tengan estado "waiting_players" o "player_1_turn" o "player_2_turn"

```text
url: .../boards?user&status[]=0&status[]=1&status[]=2
```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Action completed successfully",
  "content": [
    {
      "player_1_name": "Tomas E",
      "player_2_name": "Jane Doe",
      "status": "Waiting_For_Players",
      "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
      "board": ["X", 0, "O", "X", 0, "O", "X", 0, 0]
    },
    {
      "player_1_name": "Tomas E",
      "player_2_name": "Jane Doe",
      "status": "Waiting_For_Players",
      "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
      "board": ["X", 0, "O", "X", 0, "O", "X", 0, 0]
    }
  ]
}
```

---

#### GET /boards/:id

Obtener un tablero

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Action completed successfully",
  "content": {
    "player_1_name": "Tomas E",
    "player_2_name": "Jane Doe",
    "status": "Waiting_For_Players",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "board": ["X", 0, "O", "X", 0, "O", "X", 0, 0]
  }
}
```

Error:

```json
{
  "status": 404,
  "message": "Board doesn't exists",
  "content": {}
}
```

---

#### POST /boards

Crear un tablero

REQUEST

```text
Request.Authorization = User Token
```

RESPONSE

Success:

```json
{
  "status": 200,
  "message": "Board Created",
  "content": {
    "player_1_name": "Tomas E",
    "player_2_name": "Jane Doe",
    "status": "Waiting_For_Players",
    "token": "b5283e68-d468-410c-8a1c-b52f8cbda245",
    "board": ["X", 0, "O", "X", 0, "O", "X", 0, 0]
  }
}
```

Error 1:

No existe el usuario

```json
{
  "status": 404,
  "message": "User with token doesn't exists",
  "content": {}
}
```

Error 2:

Error al guardar el tablero

```json
{
  "status": 400,
  "message": "Error creating Board",
  "content": {}
}
```

---

#### POST /boards/:id/join

---

#### POST /boards/:id/start_game

---

#### POST /boards/:id/bet_wins

---

#### POST /boards/:id/throw_card

---

#### POST /boards/:id/cards

---

#### GET /boards/:id/cards

---
