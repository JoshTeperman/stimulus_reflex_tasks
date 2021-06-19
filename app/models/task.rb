class Task < ApplicationRecord
  belongs_to :list

  def completed?
    completed_at.present?
  end

  scope :incomplete_first, -> { order(completed_at: :desc) }
  scope :active, -> { where(deleted_at: nil) }
end
