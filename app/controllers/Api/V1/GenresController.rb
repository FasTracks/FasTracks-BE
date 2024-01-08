# frozen_string_literal: true

module Api
  module V1
    class GenresController < ApplicationController
      def index
        if params[:token] == ''
          render json: { error: { message: 'No token provided', status: 401 } }
        elsif params[:token]

          conn = Faraday.new(url: 'https://api.spotify.com/') do |faraday|
            faraday.headers['Authorization'] = "Bearer #{token}"
            faraday.adapter Faraday.default_adapter
          end

          response = conn.get('v1/recommendations/available-genre-seeds')

          JSON.parse(response.body, symbolize_names: true)
        end
      end
    end
  end
end
