class SlackPoster
  require 'slack-notifier'

  def initialize(options = Rails.application.secrets)
    self.client = Slack::Notifier.new(options.aimco_slack_webhook_url)
  end

  def post(message)
    client.ping message
  end

  private

  attr_accessor :client
end
