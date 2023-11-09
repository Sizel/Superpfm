FactoryBot.define do
  factory :connection do
    sequence(:connection_id) { SecureRandom.uuid }
    provider_code { "fakebank_simple_xf " }
    status { "active" }
    next_refresh_possible_at { Time.zone.now }

    user
  end
end
