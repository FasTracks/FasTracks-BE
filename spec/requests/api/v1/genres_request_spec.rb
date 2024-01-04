require 'rails_helper'

describe "Genres API" do
  it "sends a list of genres", :vcr do
    create_list(:genre, 10)

    get "/api/v1/genres?bearer=1234"

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


  it "errors without a token", :vcr do
    create_list(:genre, 10)

    get '/api/v1/genres?genre=pop'

    expect(response).to_not be_successful
    expect(json[:error][:message]).to eq("No token provided")  
    expect(json[:error][:status]).to eq(401)  
  end

  it "errors with a bad token", :vcr do
    create_list(:genre, 10)

    get "/api/v1/genres?bearer=1234"

    expect(response).to_not be_successful
    expect(json[:error][:message]).to eq("Invalid token")  
    expect(json[:error][:status]).to eq(401)  
  end
end
