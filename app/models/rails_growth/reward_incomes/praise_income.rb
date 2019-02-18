class PraiseIncome < RewardIncome
  belongs_to :gift, foreign_key: :source_id, counter_cache: true

end
