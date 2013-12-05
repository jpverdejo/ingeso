# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Ingeso::Application.initialize!

config.to_prepare do
    Devise::SessionsController.layout proc{ |controller| action_name == 'new' ? "devise"   : "login" }
end