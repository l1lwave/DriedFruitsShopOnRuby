class RemoveStatusFromCallbackRequests < ActiveRecord::Migration[8.0]
  def change
    remove_column :callback_requests, :status, :string
  end
end
