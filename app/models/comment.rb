class Comment < ApplicationRecord
  validates :description, presence: true, length: { minumum: 4, maximum: 140 }
  validates :user_id, presence: true
  validates :recipe_id, presence: true

  belongs_to :user
  belongs_to :recipe

  default_scope -> { order(updated_at: :desc) }
end