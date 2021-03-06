Then(/^I configure Vigia with the following options:$/) do |config_table|
  @stderr = StringIO.new
  @stdout = StringIO.new

  Vigia.configure do |config|
    config_table.rows_hash.each do |name, value|
      if name == 'source_file'
        config.send("#{ name }=", File.join(__dir__, '../support/examples', value))
      elsif name == 'host'
        app, method = value.split('.')
        config.host = @running_apps[app].send(method)
      end
    end

    config.rspec_config do |rspec_config|
      rspec_config.reset
      if config_table.rows_hash.has_key?('rspec_formatter')
        rspec_config.formatter = eval(config_table.rows_hash['rspec_formatter'])
      else
        rspec_config.formatter = RSpec::Core::Formatters::DocumentationFormatter
      end
    end

    config.stderr = @stderr
    config.stdout = @stdout
  end
  @config = Vigia.config
end

Then(/^I configure a "(.*?)" hook with this block:$/) do |filter, proc_content|
  proc_object = eval("-> { #{ proc_content } }")
  @config.send(filter, &proc_object)
end




