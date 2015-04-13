Biblechallenge::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  Biblechallenge::Application.config.session_store :cookie_store, key: 'bible_application_devise_session', domain: ".lvh.me", tld_length: 2


  config.middleware.use "CustomDomainCookie", ".lvh.me"

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  #devise options
  config.action_mailer.default_url_options = { host: 'lvh.me:3000' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address  => "localhost",
    :port                 => 1025
    }


  # add db logging
  config.active_record_logger = Logger.new("log/sql.log")
end
