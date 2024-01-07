require "rails_helper"

describe SpotifyService do
  context "class methods" do
    context "#members_by_state" do
      it "returns member data" do
        search = CongressService.new.members_by_state("CO")
        expect(search).to be_a Hash
        expect(search[:results]).to be_an Array
        member_data = search[:results].first

        expect(member_data).to have_key :name
        expect(member_data[:name]).to be_a(String)

        expect(member_data).to have_key :role
        expect(member_data[:role]).to be_a(String)

        expect(member_data).to have_key :district
        expect(member_data[:district]).to be_a(String)

        expect(member_data).to have_key :party
        expect(member_data[:party]).to be_a(String)
      end
    end
  end
end