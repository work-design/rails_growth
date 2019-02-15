class PraiseIncome < RewardIncome
  belongs_to :reward_coin, foreign_key: :source_id, counter_cache: true

end
