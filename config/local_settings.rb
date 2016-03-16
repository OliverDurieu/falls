if Rails.env == "production"
	BASE_URL = "http://www.lamule.com.au"
  STORAGE_TYPE = :fog
else
	BASE_URL = "http://localhost:3000"
  STORAGE_TYPE = :file
end
BUCKET_NAME = "eduleaf-development"

AWS_KEY_ID = "AKIAIXBFPW64VUEHLDFQ"
AWS_KEY = "OsRXq2w6H0TAPXFRL4LXUhWKMhfhFp39YOxG4Onr"

ASSET_HOST = "https://d114xxgzhq47ua.cloudfront.net"