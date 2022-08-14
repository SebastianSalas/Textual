class CreateConvertImages < ActiveRecord::Migration[7.0]
  def change
    create_table :convert_images do |t|
      t.string :name
      t.string :image_binary
      t.string :text_result
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
