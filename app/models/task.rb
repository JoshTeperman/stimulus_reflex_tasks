class Task < ApplicationRecord
  acts_as_list scope: [:list_id, completed_at: nil], top_of_list: 0
  belongs_to :list
  belongs_to :creator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :assignee, foreign_key: 'assignee_id', class_name: 'User', optional: true
  belongs_to :completer, foreign_key: 'completer_id', class_name: 'User', optional: true
  has_many :comments, as: :commentable

  delegate :name, to: :assignee, prefix: true, allow_nil: true
  delegate :name, to: :completer, prefix: true, allow_nil: true

  validates_presence_of :name

  def completed?
    completed_at.present?
  end

  scope :active, -> { where(deleted_at: nil) }
  scope :complete, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }
end
