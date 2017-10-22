class Game < ActiveRecord::Base
  belongs_to :angle

  def default?
    self.name == 'default'
  end

  def self.default
    self.find_by_name('default')
  end

  scope :available, -> { where.not(name: 'default') }
end

