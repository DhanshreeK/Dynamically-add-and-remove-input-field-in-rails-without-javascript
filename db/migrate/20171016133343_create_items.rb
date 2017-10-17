class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :price
      t.string :quantity
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
