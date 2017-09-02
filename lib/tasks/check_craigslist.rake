namespace :craigslist do
  desc "Check if there is a new listing available. If so, notify through Slack."
  task :check, [:url] => :environment do |t, args|
    CraigslistChecker.run(args[:url])
  end

  desc "Load all available listings initially (so you do not receive multiple notifications at once)"
  task :load, [:url] => :environment do |t, args|
    CraigslistChecker.load(args[:url])
  end

  desc "Test the notification system by running it for one listing"
  task :test, [:url] => :environment do |t, args|
    Listing.last.destroy
    CraigslistChecker.run(args[:url])
  end
end
