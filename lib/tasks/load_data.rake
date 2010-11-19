desc "Load data into database from YAML files in db/data/.
Relies on RAILS_ENV to determine database."

task :load_data => :environment do
  require 'active_record/fixtures'
  datadir = "#{RAILS_ROOT}/db/data"
  ActiveRecord::Base.establish_connection
  Dir.glob("#{datadir}/*.{yml,csv}").each do |file|
    Fixtures.create_fixtures('db/data', File.basename(file, '.*'))
  end
end
