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
      expect(tasks[0].keys).to match_array(%w[id type attributes])
      expect(tasks[0]['attributes'].keys).to match_array(%w[title completed created-at updated-at])
    end
  end

  private

  def response_body
    JSON.parse(response.body)
  end
end
