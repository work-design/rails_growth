module Growth
  class PraiseIncome < ApplicationRecord
    include Model::PraiseIncome
    include Model::PraiseCompute
    include Model::RoyaltyCompute
  end
end
