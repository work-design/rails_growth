class RewardExpense < ApplicationRecord
  belongs_to :reward, counter_cache: :expenses_count

end
