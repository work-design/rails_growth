class CoinLog < ApplicationRecord
  belongs_to :source, polymorphic: true

end
