# frozen_string_literal: true

module V1
  # CURD controller for tasks
  class TasksController < ApplicationController
    def index
      @tasks = Task.all
      render json: @tasks
    end
  end
end
