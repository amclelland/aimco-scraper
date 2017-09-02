class CraigslistChecker
  require 'nokogiri'
  attr_reader :url

  def self.run(url)
    new(url).run
  end

  def self.load(url)
    new(url).load
  end

  def initialize(url)
    url = Rails.application.secrets.craigslist_url if url.blank?
    
    @url = url
  end

  def run
    new_listings.each do |listing|
      slack_poster.post(listing.message)
    end
  end
  
  def load
    new_listings
  end

  private

  def slack_poster
    @slack_poster ||= SlackPoster.new
  end
  
  def page
    @page ||= Page.new(doc, url)
  end

  def doc
    @doc ||= Nokogiri::HTML(open(url))
  end
  
  def new_listings
    listings.map do |listing|
      pid = listing.keys[0]
      url = listing.values[0]
      
      listing = Listing.where(pid: pid).first_or_initialize(url: url)
      listing.new_record? && listing.save! ? listing : nil
    end.compact
  end
  
  def listings
    doc.css('.result-row[data-pid]').map do |result|
      {
        result.attributes['data-pid'].value =>
        [
          domain,
          result.children[1].attributes['href'].value
        ].join
      }
    end
  end
  
  def domain
    @domain ||= "https://#{URI.parse(url).host}"
  end
end
