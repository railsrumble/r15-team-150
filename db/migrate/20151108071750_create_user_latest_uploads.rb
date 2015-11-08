class CreateUserLatestUploads < ActiveRecord::Migration
  def change
    create_table :user_latest_uploads do |t|
      t.string :file_name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
