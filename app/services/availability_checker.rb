class AvailabilityChecker
  require 'nokogiri'
  attr_reader :domain

  def self.run(domain)
    new(domain).run
  end

  def self.load(domain)
    new(domain).load
  end

  def initialize(domain)
    @domain = domain
  end

  def run
    page.new_apartments.each do |apartment|
      slack_poster.post(apartment.message)
    end
  end

  def load
    page.new_apartments
  end

  private

  def slack_poster
    @slack_poster ||= SlackPoster.new
  end

  def doc
    @doc ||= Nokogiri::HTML(open(xhr_url))
  end

  def page
    @page ||= Page.new(doc, domain)
  end

  def xhr_url
    @xhr_url ||= domain + '/en/apartments/availability/jcr:content/par/apartmentlister.json.apartments.....html'
  end

  class Page < AvailabilityChecker
    attr_reader :doc, :domain

    def initialize(doc, domain)
      @doc    = doc
      @domain = domain
    end

    def new_apartments
      apartments
    end

    private

    def apartments
      raw_apartments.map do |raw_apartment|
        RawApartment.new(raw_apartment, @domain).record
      end.compact
    end

    def raw_apartments
      doc.css('.matched_apartments')[0].css('.listertabs_content_item')
    end

    def available_apartments_count
      available_apartments_text[/\d+/].to_i
    end

    def available_apartments_text
      doc.css('.match_results')[0].text.strip
    end

    class RawApartment < Page
      attr_reader :html, :domain

      def initialize(html, domain)
        @html   = html
        @domain = domain
      end

      def record
        apartment = Apartment.where(number: number).first_or_initialize(
          price_range: price_range,
          url: url,
          floorplan: floorplan
        )

        return apartment if apartment.new_record? && apartment.save!
      end

      private

      def price_range
        html.css('.features_item_pricing').text.match(/Price\s*(.*)$/)[1].strip
      end

      def url
        @domain + raw_link[0]['href'].strip
      end

      def floorplan
        link_text.match(/\((.*)\)/)[1].strip
      end

      def number
        link_text.match(/Apt (.*) \(/)[1].strip
      end

      def link_text
        raw_link.text.squish
      end

      def raw_link
        html.css('.floorcheck>a')
      end
    end
  end
end
