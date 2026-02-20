# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
admin_password = if Rails.env.production?
  ENV.fetch("ADMIN_PASSWORD")
else
  ENV.fetch("ADMIN_PASSWORD", "password")
end

admin = User.find_or_initialize_by(email_address: admin_email)

if admin.new_record?
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.save!
elsif ENV.fetch("ADMIN_RESET_PASSWORD_ON_SEED", "0") == "1"
  admin.update!(password: admin_password, password_confirmation: admin_password)
end
