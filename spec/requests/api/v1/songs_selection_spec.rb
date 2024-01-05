require 'rails_helper'

describe "Song Selection" do
  it "Returns a selection of songs based on genre, BPM and duration" do
    json_response = File.read('spec/fixtures/songs_selection/songs.json')

    stub_request(:get, "https://api.spotify.com/v1/recommendations?limit=10&seed_genres=pop&target_tempo=140").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer 1234',
          'User-Agent'=>'Faraday v2.8.1'
           }).
         to_return(status: 200, body: json_response, headers: {})

    get "/api/v1/songs?bearer=1234&&workout=HIIT&&genre=pop"

    expect(response).to be_successful
    # require 'pry'; binding.pry
    # expect(response).to be_json

    parsed_response = JSON.parse(json_response, symbolize_names: true)

    expect(parsed_response).to have_key(:tracks)

    parsed_response[:tracks].each do |track|
      expect(track).to have_key(:uri)
      expect(track).to have_key(:name)
      expect(track[:uri]).to be_a(String)
      expect(track[:name]).to be_a(String)

        track[:artists].each do |artist|
          expect(artist[:name]).to be_a(String)
        end
    end
  end 
end 