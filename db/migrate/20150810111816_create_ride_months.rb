class CreateRideMonths < ActiveRecord::Migration
  def change
    create_table :ride_months do |t|
      t.boolean :jan
      t.boolean :feb
      t.boolean :mar
      t.boolean :apr
      t.boolean :may
      t.boolean :jun
      t.boolean :jul
      t.boolean :aug
      t.boolean :sep
      t.boolean :oct
      t.boolean :nov
      t.boolean :dec
      t.integer :date_type
      t.belongs_to :ride, index: true
      t.timestamps
    end
  end
end
