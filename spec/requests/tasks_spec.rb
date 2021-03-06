# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::TasksController, type: :request do
  describe 'GET /tasks' do
    before do
      FactoryBot.create_list(:task, 2, completed: false)
      FactoryBot.create_list(:task, 3, completed: true)
    end

    context 'without a filter value' do
      it 'shows tasks' do
        get '/v1/tasks'
        expect(response).to have_http_status(:success)

        tasks = response_body['data']
        expect(tasks.size).to eq(5)
        tasks.each { |task| expect_json_api_task(task) }
      end
    end

    context 'only active' do
      it 'shows tasks' do
        get '/v1/tasks?filter[status]=active'
        expect(response).to have_http_status(:success)

        tasks = response_body['data']
        expect(tasks.size).to eq(2)
        expect(tasks).to be_all do |task|
          task['attributes']['completed'] == false
        end
      end
    end

    context 'only completed' do
      it 'shows tasks' do
        get '/v1/tasks?filter[status]=completed'
        expect(response).to have_http_status(:success)

        tasks = response_body['data']
        expect(tasks.size).to eq(3)
        expect(tasks).to be_all do |task|
          task['attributes']['completed'] == true
        end
      end
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

    context 'invalid request' do
      let(:task_params) do
        {
          data: {
            type: 'tasks',
            attributes: {
              title: ''
            }
          }
        }
      end

      it 'returns invalid ' do
        post '/v1/tasks', params:  task_params

        expect(response).to have_http_status(422)
        expect(response_body['errors']).to be_present
        error = response_body['errors'].first
        expect(error['detail']).to eq("can't be blank")
        expect(error.dig('source', 'pointer')).to eq('/data/attributes/title')
      end

      it 'not creates a task in database' do
        expect do
          post '/v1/tasks', params: task_params
        end.to_not change(Task, :count)
      end
    end
  end

  describe 'GET /task/:id' do
    context 'with an exists task' do
      let!(:task) { FactoryBot.create(:task) }

      it 'shows a task' do
        get "/v1/tasks/#{task.id}"
        expect(response).to have_http_status(:success)

        resp_task = response_body['data']
        expect_json_api_task(resp_task)
        expect(resp_task['id']).to eq(task.id.to_s)
      end
    end

    context 'when the task is not exists' do
      it 'shows a task' do
        get '/v1/tasks/any'
        expect(response).to have_http_status(404)
        expect(response_body['errors']).to contain_exactly(
          'status' => '404',
          'title' => 'Not Found'
        )
      end
    end
  end

  describe 'PUT /task/:id' do
    let!(:task) { FactoryBot.create(:task, title: 'Change me') }
    before { put "/v1/tasks/#{task.id}", params: update_params }

    context 'params with valid params' do
      let(:update_params) do
        {
          data: {
            type: 'tasks',
            attributes: {
              title: 'To do me!',
              completed: true
            }
          }
        }
      end

      it 'returns the updated record' do
        expect(response).to have_http_status(200)

        expect_json_api_task(response_body['data'])
        resp_task = response_body['data']['attributes']
        expect(resp_task['title']).to eq('To do me!')
        expect(resp_task['completed']).to eq(true)
      end

      it 'updated the db record' do
        expect(task.reload.title).to eq('To do me!')
        expect(task.completed).to eq(true)
      end
    end

    context 'params with an invalid title' do
      let(:update_params) do
        {
          data: {
            type: 'tasks',
            attributes: {
              title: ''
            }
          }
        }
      end

      it 'returns an error' do
        expect(response).to have_http_status(422)

        expect(response_body['errors']).to be_present
        error = response_body['errors'].first
        expect(error['detail']).to eq("can't be blank")
        expect(error.dig('source', 'pointer')).to eq('/data/attributes/title')
      end

      it 'not changes the db record' do
        expect(task.reload.title).to eq('Change me')
        expect(task.completed).to eq(false)
      end
    end
  end

  describe 'DELETE /task/:id' do
    let!(:task) { FactoryBot.create(:task) }
    before { delete "/v1/tasks/#{task.id}" }

    it 'returns proper status code' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the record' do
      expect(Task).to_not be_exists(task.id)
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
