require 'rails_helper'

describe 'Genres API' do
  xit 'sends a list of genres' do
    json_response = File.read('spec/fixtures/genre_requests/genres.json')

    stub_request(:get, 'https://api.spotify.com/v1/recommendations/available-genre-seeds')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer 1234',
          'User-Agent' => 'Faraday v2.8.1'
        }
      )
      .to_return(status: 200, body: json_response, headers: {})

    get '/api/v1/genres?bearer=1234'

    expect(response).to be_successful

    parsed_response = JSON.parse(json_response, symbolize_names: true)

    expect(parsed_response).to have_key(:genres)
    expect(parsed_response[:genres].first).to be_a(String)
  end

  xit 'errors without a token' do
    json_response = File.read('spec/fixtures/genre_requests/genres_no_token.json')

    stub_request(:get, 'https://api.spotify.com/v1/recommendations/available-genre-seeds')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer',
          'User-Agent' => 'Faraday v2.8.1'
        }
      )
      .to_return(status: 401, body: json_response, headers: {})

    get '/api/v1/genres?bearer='

    expect(response).to be_successful

    # parsed_response = JSON.parse(response.body, symbolize_names: true)
    # expect(parsed_response[:error][:message]).to eq("No token provided")
    # expect(parsed_response[:error][:status]).to eq(401)
  end

  xit 'errors with a bad token' do
    json_response = File.read('spec/fixtures/genre_requests/genres_bad_token.json')

    stub_request(:get, 'https://api.spotify.com/v1/recommendations/available-genre-seeds')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer 1235',
          'User-Agent' => 'Faraday v2.8.1'
        }
      )
      .to_return(status: 401, body: json_response, headers: {})

    get '/api/v1/genres?bearer=1235'

    # expect(response).to_not be_successful

    # parsed_response = JSON.parse(response.body, symbolize_names: true)
    # expect(parsed_response[:error][:message]).to eq("Invalid access token")
    # expect(parsed_response[:error][:status]).to eq(401)
  end
end
