RSpec.describe User, type: :model do
  describe "callbacks" do
    describe "before_create" do
      let(:user) { build(:user) }

      it "creates a customer" do
        user.customer_id = nil
        expect_any_instance_of(SaltedgeClient).to receive(:create_customer)
          .with(user.email)
          .and_return("data" => { "id" => "123" })

        user.save
        expect(user.customer_id).to eq("123")
      end

      it "does not create a customer if customer_id is already present" do
        user.customer_id = "123"
        expect_any_instance_of(SaltedgeClient).not_to receive(:create_customer)
        user.save
      end
    end
  end
end
