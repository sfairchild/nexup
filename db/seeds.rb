Game.delete_all
Angle.delete_all
Battle.delete_all
BattleUser.delete_all

default_angle = Angle.create(pivot: 90)
Game.create(name: 'default', angle_id: default_angle.id)

tv = Angle.create(pivot: 20)
Game.create(name: 'halo', angle: tv)
Game.create(name: 'smash', angle: tv)
Game.create(name: 'magic', angle: Angle.new(pivot: 180))
Game.create(name: 'pong', angle: Angle.new(pivot: 120))
Game.create(name: 'foosball', angle: Angle.new(pivot: 40))
