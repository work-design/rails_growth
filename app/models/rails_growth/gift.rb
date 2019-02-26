class Gift < ApplicationRecord
  has_many :praise_incomes, as: :source

  has_one_attached :icon

  validates :code, uniqueness: true

  def icon_url
    icon.service_url if icon.attachment.present?
  end

  def give_to(reward, user)
    praise = self.praise_incomes.build
    praise.reward = reward
    praise.user = user
    praise.received_amount = self.amount

    praise.save
    praise
  end

end
