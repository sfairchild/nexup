class Battle < ActiveRecord::Base
  belongs_to :game
  has_many :battle_users

  before_create do
    self.name = "Battle of House #{Faker::GameOfThrones.house} in the city of #{Faker::GameOfThrones.city}"
  end
end
