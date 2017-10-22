Game.delete_all
Angle.delete_all

default_angle = Angle.create(pivot: 90)
default = Game.create(name: 'default', angle_id: default_angle.id)

