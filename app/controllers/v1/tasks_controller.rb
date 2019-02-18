# frozen_string_literal: true

module V1
  # CURD controller for tasks
  class TasksController < ApplicationController
    before_action :set_task, only: %i[show update destroy]

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

    def show
      render json: @task
    end

    def update
      if @task.update(task_attributes)
        render json: @task
      else
        render json: @task, status: 422, serializer: ActiveModel::Serializer::ErrorSerializer
      end
    end

    def destroy
      @task.delete
      render nothing: true, status: :no_content
    end

    private

    def task_attributes
      task_params[:attributes]
    end

    def task_params
      params.require(:data).permit(:type, attributes: %i[title completed])
    end

    def set_task
      @task = Task.find(params[:id])
    end
  end
end
