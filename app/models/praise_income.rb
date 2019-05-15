class PraiseIncome < ApplicationRecord
  include RailsGrowth::PraiseIncome
  include RailsGrowth::PraiseCompute
  include RailsGrowth::RoyaltyCompute
end unless defined? PraiseIncome
