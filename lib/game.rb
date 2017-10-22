class Game < ActiveRecord::Base
  def self.default
    self.find_by_name('default')
  end
end

