class Reward < ApplicationRecord
  belongs_to :entity, polymorphic: true

end
