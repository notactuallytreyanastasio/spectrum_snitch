log_path = ENV.fetch("SNITCH_LOG_PATH")
csv_path = ENV.fetch("SNITCH_CSV_PATH")
program_path = ENV.fetch("PROGRAM_PATH")

every 2.minutes do
  command "source #{program_path}/.env && echo 'beginning check' >> #{log_path} && ruby #{program_path}/main.rb && echo 'finished check' >> #{log_path}"
end

