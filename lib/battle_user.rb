class BattleUser < ActiveRecord::Base
  belongs_to :battle

  validates_uniqueness_of :user_name, scope: :battle

  scope :ready_for_battle, -> {where(in: true)}
end
