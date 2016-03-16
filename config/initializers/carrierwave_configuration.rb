CarrierWave.configure do |config|
	config.fog_credentials = {
			provider: "AWS",
			aws_access_key_id: AWS_KEY_ID,
			aws_secret_access_key: AWS_KEY
	}
	config.fog_directory = BUCKET_NAME
	# config.asset_host = ASSET_HOST
end