require 'rails_helper'

describe "Genres API" do
  it "sends a list of genres" do
    create_list(:genre, 10)

    get '/api/v1/genres'

    expect(response).to be_successful
  end
end