class CoinExchange < ApplicationRecord
  attribute :state, :string, default: 'pending'
  belongs_to :user
  belongs_to :coin, primary_key: :user_id, foreign_key: :user_id, inverse_of: :coin_exchanges
  has_one :coin_log, as: :source, primary_key: :user_id, foreign_key: :user_id

  enum state: {
    pending: 'pending',
    handling: 'handling',
    done: 'done'
  }

  after_save :sync_to_coin, if: -> { saved_change_to_coin_amount? }
  after_create_commit :sync_coin_log

  def sync_coin_log

  end

  def sync_to_coin
    self.coin || create_coin
    coin.compute_amount
    coin.save!
  end

end
