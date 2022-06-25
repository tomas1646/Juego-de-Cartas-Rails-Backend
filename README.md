# Programacion Avanzada TaTeTi

## Endpoints

### Player

| Metodo | Ruta                    | Accion                        |
| ------ | ----------------------- | ----------------------------- |
| PUT    | /players                | [Registrar Usuario]           |
| PUT    | /players                | [Actualizar Usuario]          |
| PUT    | /players/login          | [Login]                       |
| PUT    | /players/update_picture | [Actualizar foto del usuario] |

### Board

| Metodo | Ruta                         | Accion                               |
| ------ | ---------------------------- | ------------------------------------ |
| GET    | /boards                      | [Obtener los tableros]               |
| GET    | /boards/:id                  | [Obtener un tablero]                 |
| PUT    | /boards                      | [Crear un tablero]                   |
| PUT    | /boards/:id/join             | [Unirse a un tablero]                |
| PUT    | /boards/:id/start_game       | [Empezar la partida]                 |
| PUT    | /boards/:id/start_card_round | [Empezar a tirar cartas]             |
| PUT    | /boards/:id/set_wins         | [Rondas que va a ganar cada jugador] |
| PUT    | /boards/:id/update_score     | [Actualizar Marcador]                |
| PUT    | /boards/:id/throw_card       | [Tirar una carta]                    |
| PUT    | /boards/:id/end_card_round   | [Terminar Ronda Actual]              |
| PUT    | /boards/:id/end_game         | [Terminar Partida]                   |
| GET    | /boards/:id/cards            | [Obtener las cartas de un jugador]   |
