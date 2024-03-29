class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
    add_index :reviews, [:user_id, :shop_id], unique: true
  end
end
