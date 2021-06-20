class Task < ApplicationRecord
  acts_as_list scope: [:list_id, completed_at: nil], top_of_list: 0
  belongs_to :list
  validates_presence_of :name

  def completed?
    completed_at.present?
  end

  scope :incomplete_first, -> { order(completed_at: :desc) }
  scope :active, -> { where(deleted_at: nil) }
end
