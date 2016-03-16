class AddNewCarCategory < ActiveRecord::Migration
  def change
  	CarCategory.create!(name: "Small Truck") if CarCategory.find_by(name: "Small Truck").blank?
  end
end
