# frozen_string_literal: true

module V1
  # CURD controller for tasks
  class TasksController < ApplicationController
    def index
      @tasks = Task.all
      render json: @tasks
    end

    def create
      @task = Task.new(task_attributes)
      if @task.save
        render json: @task, status: :created, location: v1_task_url(@task)
      else
        render json: @task, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
      end
    end

    private

    def task_attributes
      task_params[:attributes]
    end

    def task_params
      params.require(:data).permit(:type, attributes: [:title])
    end
  end
end
