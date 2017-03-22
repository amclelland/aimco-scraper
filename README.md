# Aimco Scraper

This tool will notify you via Slack when there are any new available apartments for an Aimco apartment complex of your choosing. Perfect for when you want to be the first one to snatch up a newly available apartment!

## Usage

Locate the Aimco property's website domain. For example, if you wanted to follow availability for The [Bay Parc Plaza apartments](http://www.bayparcplaza.com/) you would use `http://www.bayparcplaza.com` (no trailing slash!)

This domain is used when running the tasks. There are three available:

```ruby
rake availability:load['http://www.bayparcplaza.com']
```
This loads all the currently available apartments (so you don't start off by getting a ton of notifications)

```ruby
rake availability:test['http://www.bayparcplaza.com']
```
You can run this after running the load task to make sure the notifications work properly.
It will delete the last available apartment and then run the check again, so you should get exactly
one notification.

```ruby
rake availability:check['http://www.bayparcplaza.com']
```
This is the task that you will run on an interval, using [Heroku Scheduler](https://elements.heroku.com/addons/scheduler) or similar. You will receive a Slack notification

## Setup

Pull and customize this repo. I suggest deploying to Heroku.

First, you will need a Slack channel to configure. Aimco Scraper uses [Slack Notifier](https://github.com/stevenosloan/slack-notifier) to send messages;
follow the second half of the [Setting Defaults](https://github.com/stevenosloan/slack-notifier#setting-defaults) section, where you set up an incoming webhook for your Slack channel. Set the webhook URL you receive:

```bash
export AIMCO_SLACK_WEBHOOK_URL="your_webhook_url"
```

Make sure to set it to the Heroku env vars.

Next, run the tasks; first `heroku run rake availability:load`, and then `heroku run rake availability:test` to make sure it is working properly. If you receive the message but do not receive a notification, check your Slack notification settings.

If it works, set up the [Heroku Scheduler](https://elements.heroku.com/addons/scheduler) next, having it run `rake availability:check` every hour (make sure to add your domain to these commands!)
