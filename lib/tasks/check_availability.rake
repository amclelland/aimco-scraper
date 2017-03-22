namespace :availability do
  desc "Check if there is a new apartment available. If so, notify through Slack."
  task :check, [:url] => :environment do |t, args|
    raise ArgumentError if args[:url].blank?

    AvailabilityChecker.run(args[:url])
  end

  desc "Load all available apartments initially (so you do not receive multiple notifications at once)"
  task :load, [:url] => :environment do |t, args|
    raise ArgumentError if args[:url].blank?

    AvailabilityChecker.load(args[:url])
  end

  desc "Test the notification system by running it for one apartment"
  task :test, [:url] => :environment do |t, args|
    raise ArgumentError if args[:url].blank?

    Apartment.last.destroy
    AvailabilityChecker.run(args[:url])
  end
end
