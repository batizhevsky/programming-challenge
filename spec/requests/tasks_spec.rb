# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::TasksController, type: :request do
  describe 'GET /tasks' do
    it 'shows tasks' do
      FactoryBot.create_list(:task, 5)

      get '/v1/tasks'
      expect(response).to have_http_status(:success)

      tasks = response_body['data']
      expect(tasks.size).to eq(5)
      expect_json_api_task(tasks[0])
    end
  end

  describe 'POST /tasks' do
    let(:task_params) do
      {
        data: {
          type: 'tasks',
          attributes: {
            title: 'A New Task'
          }
        }
      }
    end

    it 'returns a correct jsonapi task' do
      post '/v1/tasks', params:  task_params

      expect(response).to have_http_status(:created)
      expect(response.headers['Location']).to match(%r{/v1/tasks/\d})
      expect_json_api_task(response_body['data'])
    end

    it 'creates a task in database' do
      expect do
        post '/v1/tasks', params: task_params
      end.to change(Task, :count)
    end
  end

  private

  def expect_json_api_task(task)
    expect(task['type']).to eq('tasks')
    expect(task.keys).to match_array(%w[id type attributes])
    expect(task['attributes'].keys).to match_array(%w[title completed created-at updated-at])
  end

  def response_body
    JSON.parse(response.body)
  end
end
