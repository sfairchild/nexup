Game.delete_all
Angle.delete_all

default_angle = Angle.create(pivot: 90)
default = Game.new(name: 'default', angle: default_angle)

