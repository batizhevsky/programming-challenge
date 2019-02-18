# frozen_string_literal: true

# Parent class for all controllers
class ApplicationController < ActionController::API
  rescue_from 'ActiveRecord::RecordNotFound' do |_exception|
    render json: {
      errors: [
        {
          status: '404',
          title: 'Not Found'
        }
      ]
    }, status: :not_found
  end
end
