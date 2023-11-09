RSpec.feature "Destroy connection", type: :feature do
  let(:user) { create(:user) }
  let!(:connection) { create(:connection, user:) }

  before do
    sign_in(user)
  end

  scenario "user clicks on 'Delete' button" do
    click_button "Delete"
    expect(DestroyConnectionJob).to have_been_enqueued
  end
end
