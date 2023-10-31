# frozen_string_literal: true

require "ruby-progressbar"

namespace :import do
  desc "Usage: rake import:user FILE='<filename.csv>' ORG=<organization_id> ADMIN=<admin_id> PROCESS=<process_id> [VERBOSE=true]'"
  # TODO: Add tests
  task user: :environment do
    def display_help
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

    display_help unless ENV.fetch("FILE", nil) && ENV.fetch("ORG", nil) && ENV.fetch("ADMIN", nil) && ENV.fetch("PROCESS", nil)

    importer = UserImporter.new ENV.fetch("FILE", nil), ENV["ORG"].to_i, ENV["ADMIN"].to_i, ENV["PROCESS"].to_i, ENV.fetch("AUTH_HANDLER", nil)

    validate_input

    csv = CSV.read(@file, col_sep: ",", headers: true, skip_blanks: true)
    check_csv(csv)

    count = CSV.read(@file).count

    puts "CSV file is #{count} lines long"

    progressbar = ProgressBar.create(title: "Importing User", total: count, format: "%t%e%B%p%%") unless @verbose

    csv.each do |row|
      progressbar.increment unless @verbose
      # Import user with parsed informations id, first_name, last_name, email
      import_data(row[0], row[1], row[2], row[3])
    end

    Rails.logger.close
  end
end
