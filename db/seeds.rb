# rails db:drop db:create db:migrate db:seed

p1 = Player.create(name: 'Tomas E', user_name: 'tomas1646', password: '1234')
p2 = Player.create(name: 'usuario1', user_name: 'usuario1', password: '1234')
Player.create(name: 'usuario2', user_name: 'usuario2', password: '1234')
Player.create(name: 'usuario3', user_name: 'usuario3', password: '1234')

b = Board.new
b.join_board p1
b.join_board p2
b.save
