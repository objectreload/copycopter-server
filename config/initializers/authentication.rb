authentication_data = YAML.load_file(Rails.root.join("config/authentication_data.yml"))
HTTP_USERNAME = authentication_data["copycopter_login"]
HTTP_PASSWORD = authentication_data["copycopter_password"]