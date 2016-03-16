class AddRemotePhotoToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :remote_photo, :string
  end
end
