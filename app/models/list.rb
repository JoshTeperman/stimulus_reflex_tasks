class List < ApplicationRecord
  has_many :tasks, -> { incomplete_first.order(position: :asc) }, dependent: :destroy
  validates_presence_of :name

  def client_id
    @client_id ||= SecureRandom.uuid
  end
end
