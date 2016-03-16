class AddNewCarCategoryUte < ActiveRecord::Migration
  def change
  	CarCategory.create!(name: "UTE") if CarCategory.find_by(name: "UTE").blank?
  end

end
