# frozen_string_literal: true

module V1
  # Serializer for Task model
  class TaskSerializer < ActiveModel::Serializer
    attributes :title, :completed, :created_at, :updated_at
  end
end
