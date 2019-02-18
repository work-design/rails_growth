class Gift < ApplicationRecord
  has_many :praise_incomes, as: :source

  validates :code, uniqueness: true

end
