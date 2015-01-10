class CreateGenerators < ActiveRecord::Migration
  def change
    create_table :generators do |t|
    	t.string :title
    	t.text :description

      t.timestamps
    end
  end
end
