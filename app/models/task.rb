# frozen_string_literal: true

# model Task contains all related to todo item.
class Task < ApplicationRecord
  scope :active, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }

  validates :title, presence: true

  def self.with_status(status)
    case status
    when 'active'
      active
    when 'completed'
      completed
    else
      all
    end
  end
end
