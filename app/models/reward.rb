class Reward < ApplicationRecord
  include RailsGrowth::Reward
  include RailsWallet::Amount
end unless defined? Reward
