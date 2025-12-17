class CreateCallbackRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :callback_requests do |t|
      t.string :phone_number
      t.string :status

      t.timestamps
    end
  end
end
