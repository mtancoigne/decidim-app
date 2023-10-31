# frozen_string_literal: true

require "ruby-progressbar"

namespace :import do
  desc "Usage: rake import:user FILE='<filename.csv>' ORG=<organization_id> ADMIN=<admin_id> PROCESS=<process_id> [VERBOSE=true]'"
  # TODO: Add tests
  task user: :environment do
    unless ENV.fetch("FILE", nil) && ENV.fetch("ORG", nil) && ENV.fetch("ADMIN", nil) && ENV.fetch("PROCESS", nil)
      puts <<~HEREDOC
        Help:
        Usage: rake import:user FILE='<filename.csv>' ORG=<organization_id> ADMIN=<admin_id> PROCESS=<process_id>
      HEREDOC
      exit 0
    end

    Rails.application.config.active_job.queue_adapter = :inline

    @verbose = ENV["VERBOSE"].to_s == "true"
    Rails.logger = if @verbose
                     Logger.new($stdout)
                   else
                     Logger.new("log/import-user-#{Time.zone.now.strftime "%Y-%m-%d-%H:%M:%S"}.log")
                   end

    importer = UserImporter.new ENV.fetch("FILE", nil), ENV["ORG"].to_i, ENV["ADMIN"].to_i, ENV["PROCESS"].to_i
    importer.validate_input
    importer.read_csv

    puts "CSV file is #{importer.line_count} lines long"

    progressbar = ProgressBar.create(title: "Importing User", total: importer.line_count, format: "%t%e%B%p%%") unless @verbose

    importer.csv.each do |row|
      progressbar.increment unless @verbose
      # Import user with parsed informations id, first_name, last_name, email
      importer.import_data(row[0], row[1], row[2], row[3])
    end

    Rails.logger.close
  end
end
