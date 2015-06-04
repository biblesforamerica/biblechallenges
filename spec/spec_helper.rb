require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
#require Rails.root.join("db/seeds.rb")
require 'rspec/rails'
require 'capybara/rspec'
require 'shoulda/matchers'

Time.zone = 'Eastern Time (US & Canada)'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  # suppress error backtrace if related to rvm or rbenv
  config.backtrace_exclusion_patterns = [/\.rvm/, /\.rbenv/, /\.gem/]

  config.infer_spec_type_from_file_location! 
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true


  config.before :each do
    if Capybara.current_driver == :selenium
      DatabaseCleaner.strategy = :truncation, {except: %w[chapters verses]}
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Timecop.return
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Include Factory Girl syntax to simplify calls to factories
  config.include FactoryGirl::Syntax::Methods

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = "random"
  config.include Devise::TestHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include Capybara::DSL

  # Include custom macros here
  config.include LoginMacros
  config.include CreationMacros
  config.include ControllerMacros, type: :controller
end

