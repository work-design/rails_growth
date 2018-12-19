class RewardIncome < ApplicationRecord
  belongs_to :reward, counter_cache: :incomes_count

end
