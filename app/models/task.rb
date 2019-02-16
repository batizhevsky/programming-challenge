# frozen_string_literal: true

# model Task contains all related to todo item.
class Task < ApplicationRecord
  validates :title, presence: true
end
