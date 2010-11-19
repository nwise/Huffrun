desc "Create data files from data in an existing database.
Relies on RAILS_ENV to determine database."

task :save_data => :environment do
  sql = "SELECT * FROM %s"
  datadir = "#{RAILS_ROOT}/db/data"  
  skip_tables = [ 'schema_migrations' ]
  ActiveRecord::Base.establish_connection
  begin
    Dir.mkdir(datadir)
  rescue SystemCallError
    # ignore failure of mkdir
  end
  (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
    i = '000000'
    File.open("#{datadir}/#{table_name}.yml", 'w') do |file|
      data = ActiveRecord::Base.connection.select_all(sql % table_name)
      file.write data.inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
    end
  end
end
