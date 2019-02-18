class Gift < ApplicationRecord
  has_many :praise_incomes, as: :source

  has_one_attached :icon

  validates :code, uniqueness: true


  def give_to(reward, user)
    praise = self.praise_incomes.build
    praise.reward = reward
    praise.user = user

    praise.save
  end

end
