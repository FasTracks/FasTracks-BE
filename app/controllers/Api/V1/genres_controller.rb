class Api::V1::GenresController < ApplicationController
  def index
    # Check that bearer token is present
    if params[:bearer] == ''
      render json: { error: { message: 'No token provided', status: 401 } }
    else
      bearer = params[:bearer]
      # Establish Faraday connection
      conn = Faraday.new(url: 'https://api.spotify.com/') do |faraday|
        faraday.headers['Authorization'] = "Bearer #{bearer}"
        faraday.adapter Faraday.default_adapter
      end
      # Make endpoint connection
      response = conn.get('v1/recommendations/available-genre-seeds')
      # Give different responses based on the status code
      if response.status == 401
        render json: { error: { message: 'Invalid access token', status: 401 } }
      elsif response.status == 404
        render json: { error: { message: 'Not Found', status: 404 } }
      elsif response.status != 200
        render json: { error: { message: 'Unexpected error', status: response.status } }
      else
        json = JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
