# rails db:drop db:create db:migrate db:seed

p1 = Player.create(name: 'Tomas E', user_name: 'tomas1646', password: '1234')
p2 = Player.create(name: 'usuario1', user_name: 'usuario1', password: '1234')
Player.create(name: 'usuario2', user_name: 'usuario2', password: '1234')
Player.create(name: 'usuario3', user_name: 'usuario3', password: '1234')

b = Board.new
b.join_board p1
b.join_board p2
b.save

b.start_game

# Round 1

b.bet_wins 1, 0
b.bet_wins 2, 1

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

# Round 2

b.bet_wins 1, 1
b.bet_wins 2, 1

b.throw_card 1, b.rounds.last.round_players[1].cards[0]
b.throw_card 2, b.rounds.last.round_players[0].cards[0]

b.throw_card 1, b.rounds.last.round_players[1].cards[0]
b.throw_card 2, b.rounds.last.round_players[0].cards[0]

b.throw_card 1, b.rounds.last.round_players[1].cards[0]
b.throw_card 2, b.rounds.last.round_players[0].cards[0]

b.throw_card 1, b.rounds.last.round_players[1].cards[0]
b.throw_card 2, b.rounds.last.round_players[0].cards[0]

# Round 3

b.bet_wins 1, 1
b.bet_wins 2, 0

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]

b.throw_card 1, b.rounds.last.round_players[0].cards[0]
b.throw_card 2, b.rounds.last.round_players[1].cards[0]
