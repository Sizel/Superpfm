RSpec.feature "Refresh connection", type: :feature do
  let(:user) { create(:user) }
  let!(:connection) { create(:connection, user:, next_refresh_possible_at: 1.day.ago) }

  before do
    sign_in(user)
  end

  scenario "user clicks on 'Refresh' button" do
    click_button "Refresh"
    expect(RefreshConnectionJob).to have_been_enqueued
  end
end
