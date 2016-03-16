class AddCarModelToHolden < ActiveRecord::Migration
  def change
  	car_maker = CarMaker.find_or_create_by(name: "Holden")
		["Barina Spark", "Barina", "Cruze", "Malibu", "Volt","Trace","Captiva5","Captiva7","Colarado7"].each do |car_model_name|
			car_maker.car_models.create!(name: car_model_name)
		end
  end
end
