# Programacion Avanzada TaTeTi

![Diagrama de clases]("https://github.com/tomas1646/Juego-de-Cartas-Rails-Backend-/blob/master/Diagrama%20Clases.jpg")

## Endpoints

### Player

| Metodo | Ruta                    | Accion                        |
| ------ | ----------------------- | ----------------------------- |
| PUT    | /players                | [Registrar Usuario]           |
| PUT    | /players                | [Actualizar Usuario]          |
| PUT    | /players/login          | [Login]                       |
| PUT    | /players/update_picture | [Actualizar foto del usuario] |

### Board

| Metodo | Ruta                   | Accion                               |
| ------ | ---------------------- | ------------------------------------ |
| GET    | /boards                | [Obtener los tableros]               |
| GET    | /boards/:id            | [Obtener un tablero]                 |
| PUT    | /boards                | [Crear un tablero]                   |
| PUT    | /boards/:id/join       | [Unirse a un tablero]                |
| PUT    | /boards/:id/start_game | [Empezar la partida]                 |
| PUT    | /boards/:id/bet_wins   | [Rondas que va a ganar cada jugador] |
| PUT    | /boards/:id/throw_card | [Tirar una carta]                    |
| GET    | /boards/:id/cards      | [Obtener las cartas de un jugador]   |
