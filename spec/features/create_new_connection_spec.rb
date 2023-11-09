RSpec.feature "Create new connection", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  scenario "user clicks on 'Create new connection' button" do
    expect_any_instance_of(SaltedgeClient).to receive(:create_connection).and_return(
      "data" => { "connect_url" => "https://www.saltedge.com/connect" }
    )

    click_button "Create new connection"

    expect(current_path).to eq("/connect")
  end
end
