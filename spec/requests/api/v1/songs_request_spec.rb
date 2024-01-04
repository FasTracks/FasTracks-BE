require 'rails_helper'

describe "Song Selection" do
  it "Returns a selection of songs based on genre, BPM and duration" do
    create_list(:song, 10)

    get '/api/v1/songs'

    expect(response).to be_successful
  end 
end 