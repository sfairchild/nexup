class Battle < ActiveRecord::Base
  belongs_to :game
  has_many :battle_users

end
