FactoryBot.define do
  factory :song do
    name { Faker::Music::Prince.song }
  end
end
