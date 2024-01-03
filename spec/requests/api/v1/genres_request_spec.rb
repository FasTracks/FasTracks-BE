require 'rails_helper'

describe "Genres API" do
  it "sends a list of genres" do
    create_list(:genre, 10)

    get '/api/v1/genres'

    expect(response).to be_successful

    genres = JSON.parse(response.body, symbolize_names: true)

    expect(genres.count).to eq(10)

    genres.each do |genre|
      expect(genre).to have_key(:id)
      expect(genre[:id]).to be_an(Integer)

      expect(genre).to have_key(:name)
      expect(genre[:name]).to be_a(String)
    end
  end
end