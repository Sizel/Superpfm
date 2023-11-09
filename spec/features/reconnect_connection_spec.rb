RSpec.feature "Reconnect existing connection", type: :feature do
  let(:user) { create(:user) }
  let!(:connection) { create(:connection, user:) }

  before do
    sign_in(user)
  end

  scenario "user clicks on 'Reconnect' button" do
    expect_any_instance_of(SaltedgeClient).to receive(:reconnect_connection).and_return(
      "data" => { "connect_url" => "https://www.saltedge.com/connect" }
    )

    click_button "Reconnect"

    expect(current_path).to eq("/connect")
  end
end
