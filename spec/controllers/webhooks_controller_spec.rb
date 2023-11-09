RSpec.describe WebhooksController, type: :controller do
  let(:connection) { create(:connection) }

  describe '#import_data' do
    context 'when data is ready to be imported' do
      context "when no error occured during a fetching process" do
        let(:webhook_data) do
          {
            "data" => {
              "connection_id" => "123",
              "customer_id" => "456",
              "stage" => "finish",
              "custom_fields" => {}
            }
          }
        end

        it 'enqueues ImportDataJob' do
          post :import_data, body: webhook_data.to_json

          expect(ImportDataJob).to have_been_enqueued
          expect(response).to have_http_status(:ok)
        end
      end

      context "when some error occured during a fetching process" do
        let(:webhook_data) do
          {
            "data" => {
              "connection_id" => "123",
              "customer_id" => "456",
              "error_class" => "SomeKindOfError",
              "error_message" => "Some error message",
              "custom_fields" => {}
            }
          }
        end

        it "enqueues ImportDataJob" do
          webhook_data["data"].delete("stage")
          webhook_data["data"]["error_class"] = "SomeKindOfError"

          post :import_data, body: webhook_data.to_json

          expect(ImportDataJob).to have_been_enqueued
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when data is not ready to be imported' do
      let(:webhook_data) do
        {
          "data" => {
            "connection_id" => "123",
            "customer_id" => "456",
            "stage" => "some_stage",
            "custom_fields" => {}
          }
        }
      end

      it 'does not create or update the connection and imports the data' do
        post :import_data, body: webhook_data.to_json

        expect(ImportDataJob).not_to have_been_enqueued
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#destroy" do
    let(:connection) { create(:connection) }

    let(:webhook_data) do
      {
        "data" => {
          "connection_id" => connection.connection_id,
          "customer_id" => "456",
        }
      }
    end

    it "destroys the connection" do
      webhook_data["data"]["connection_id"] = connection.connection_id

      delete :destroy, body: webhook_data.to_json

      expect(DestroyConnectionFromDbJob).to have_been_enqueued
      expect(response).to have_http_status(:ok)
    end
  end
end
