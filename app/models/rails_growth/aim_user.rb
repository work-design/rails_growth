class AimUser < ApplicationRecord
  attribute :state, :string, default: 'task_doing'
  attribute :coin_amount, :integer, default: 0

  belongs_to :aim, optional: true
  belongs_to :user, optional: true
  belongs_to :coin, foreign_key: :user_id, primary_key: :user_id, optional: true
  has_one :coin_log, ->(o) { where(user_id: o.user_id) }, as: :source
  has_many :aim_entities, ->(o){ where(user_id: o.user_id) }, foreign_key: :aim_id, primary_key: :aim_id

  enum state: {
    task_doing: 'task_doing',
    task_done: 'task_done'
  }

  def progress
    [aim_entities_count.to_i, aim.task_point]
  end

  def sync_log
    cl = self.coin_log || self.build_coin_log
    cl.title = I18n.t('coin_log.income.aim_user.title')
    cl.tag_str = I18n.t('coin_log.income.aim_user.tag_str')
    cl.amount = self.coin_amount
    cl.save
  end

  def sync_to_coin
    coin.reload
    coin.income_amount += self.coin_amount
    if coin.income_amount == coin.compute_income_amount
      coin.save!
    else
      coin.errors.add :income_amount, 'not equal'
      logger.error "#{self.class.name}/Coin: #{coin.errors.full_messages.join(', ')}"
      raise ActiveRecord::RecordInvalid.new(coin)
    end
  end

end
