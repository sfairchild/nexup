class BattleUser < ActiveRecord::Base
  belongs_to :battle

  validates_uniqueness_of :user_name, scope: :battle
end
