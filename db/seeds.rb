Game.delete_all
Angle.delete_all
Battle.delete_all
BattleUser.delete_all

default_angle = Angle.create(pivot: 90)
default = Game.create(name: 'default', angle_id: default_angle.id)

Game.create(name: 'halo', angle: Angle.new(pivot: 20))
Game.create(name: 'smash', angle: Angle.new(pivot: 0))
Game.create(name: 'magic', angle: Angle.new(pivot: 180))
Game.create(name: 'pong', angle: Angle.new(pivot: 120))
Game.create(name: 'foosball', angle: Angle.new(pivot: 40))
