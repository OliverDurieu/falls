require 'rails_helper' 
	RSpec.describe User, :type => :model do
		 it { should validate_presence_of(:gender) }
		 it { should validate_presence_of(:first_name) }
		 it { should validate_presence_of(:last_name) }
		 it { should validate_presence_of(:birth_year) }
		it "user should sign in" do
		  user = FactoryGirl.create(:user)
		  expect(User.last().email).to eq(user.email)
		end

		it "user should not sign in" do
		  user = FactoryGirl.create(:user, email: "batman@gmail.com", password: "secret",password_confirmation: "secret")
		  expect(User.last().email).not_to eq("alex@gmail.com")
		end

		it "Should not create two users with same email" do
		  FactoryGirl.create(:user, email: "batman@gmail.com")
		  expect { FactoryGirl.create(:user, email: "batman@gmail.com") }.to raise_error
		end

		it "should display first name of user" do
	    user = FactoryGirl.create(:user)
	    expect(user.display_first_name) == (user.first_name)
  	end

  	it "should display first and last name of user" do
	    user = FactoryGirl.create(:user)
	    expect(user.display_first_last_name) == (user.first_name+" "+user.last_name)
  	end

  	it "should display age of user" do
	    user = FactoryGirl.create(:user)
	    expect(user.age) == ("#{Date.today.year - user.birth_year} years old")
  	end

		it "should have one phone number" do
			should have_one(:phone_number)
		end

		it "should have one profile" do
			should have_one (:profile)
		end	

		it "should have one preference" do
			should have_one (:preference)
		end

		it "should have one unsubscribe" do
			should have_one (:unsubscribe)
		end
		
		it "should have many notifications" do
			should have_many (:notifications)
		end

		it "should have many rides" do
			should have_many (:rides)
		end

		it "should have many cars" do
			should have_many (:cars)
		end

		it "should have mny email_alerts" do
			should have_many (:email_alerts)
		end

		it "should have many friends" do
			should have_many (:friends)
		end

		it "should have many message threads" do
			should have_many(:message_threads)
		end

		it "should have many ratings" do
			should have_many(:ratings)
		end
		
		it "should have many visitors" do
			should have_many(:visitors)
		end
	end