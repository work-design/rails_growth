module RailsGrowth::Gift
  extend ActiveSupport::Concern
  included do
    attribute :praise_incomes_count, :integer, default: 0
  
    has_many :praise_incomes, as: :source
    has_one_attached :icon
  end
  
  def icon_url
    icon.service_url if icon.attachment.present?
  end

  def give_to(reward, user)
    praise = self.praise_incomes.build
    praise.reward = reward
    praise.user = user
    praise.amount = self.amount

    praise.save
    praise
  end

end
