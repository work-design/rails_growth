class PraiseUser < ApplicationRecord
  include RailsGrowth::PraiseUser
  include RailsGrowth::PraiseCompute
  include RailsGrowth::RoyaltyCompute
end unless defined? PraiseUser
