# Spectrum Snitch
I got sick of how much my internet was going out with Spectrum.

I decided that since they aggressively offer to pro-rate your rates if you give them specific data on your outage time, that I would just automate the task with cron and email them the spreadsheet breakdown at the end of each month.


## Quick Start
So you want a CSV that tracks if you have internet all day every day in 2 minute intervals?
Sweet heres how we set it up

```shell
$ git clone https://github.com/notactuallytreyanastasio/spectrum_snitch
$ cd spectrum_snitch
$ gem install whenever
$ bundle
# this is the absolute path to where you want logs
$ echo 'export SNITCH_LOG_PATH="/path/to/where/you/want/the/log.log"' >> .env
# this is the actual data csv
$ echo 'export SNITCH_CSV_PATH="/path/to/where/you/want/the/csv_data.csv"' >> .env
# this is the path to this repository (with no slash at the end)
$ echo 'export PROGRAM_PATH="/path/to/this/git/directory/with/no/trailing/slash"' >> .env
# and optionally, the website to check (defaults to example.com)
$ echo 'export CHECK_SITE="https://news.ycombinator.com"'
$ source .env
$ bundle exec whenever --update-crontab
```

From here, tail the path to your log. Within 2-3 minutes if you dont see a start and a finish message, something went wrong.

Try sourcing the env and running it with `ruby main.rb` to debug.
Pry is installed in the Gemfile.

## What it does
This runs in cron using a ruby script to either grab the frontpage of hacker news or a domain of your choice (example.com would probably make more sense, but whatever) and then if the socket blows or it times out, it writes a bad log.

If it succeeds, writes a good log.

This is all stored in a simple CSV you can throw into your spreadsheet tool of choice to graph.

It runs every 2 minutes.

The date and datetime of each connected/disconnected state are logged so you can do breakdowns by hour or just easily grab % of day your connection was working.

Obviously if your computers off this wont be running so unless you have it just kinda plugged in almost 24/7 like me, YMMV.

Heres how to use it

## Usage

First, we set some env vars, in a `.env` file.

```
SNITCH_LOG_PATH=absolute_path_to_where_you_want_the_log
SNITCH_CSV_PATH=absolute_path_to_where_you_want_your_data_stashed
PROGRAM_PATH=absolute_path_to_main_dot_rb_here
CHECK_SITE=some_full_url
```

An example one would look like so:

```
SNITCH_LOG_PATH=/Users/robertgrayson/spectrum_snitch/snitch.log
SNITCH_CSV_PATH=/Users/robertgrayson/spectrum_snitch/monitor.csv
PROGRAM_PATH=/Users/robertgrayson/spectrum_snitch/main.rb
CHECK_SITE=https://news.ycombinator.com
```

There is also one included at `.env.sample`.

You can fill it in with your values easily just by `cp`ing it and getting yours in.

Then, we open up `config/schedule.rb`, it looks like so:

```ruby
log_path = ENV["SNITCH_LOG_PATH"]
csv_path = ENV["SNITCH_CSV_PATH"]
program_path = ENV["PROGRAM_PATH"]

every 2.minutes do
  command "echo 'beginning check' >> #{log_path} && ruby #{program_path} && echo 'finished check' >> #{log_path}"
end
```

So, this is pretty much configured for you.
To configure your crontab do the following:

```
$ source .env
$ gem install whenever
$ bundle exec whenever --update-crontab
```

And now itll be running.

Check our logs for a start/finish and if you see that you should see a populated CSV.
It will look like this:


```
full_datetime,date,connection_state
2021-01-07 05:02:00 -0500,2021-01-07,disconnected
2021-01-07 05:12:00 -0500,2021-01-07,disconnected
2021-01-07 05:13:03 -0500,2021-01-07,disconnected
2021-01-07 05:14:00 -0500,2021-01-07,disconnected
2021-01-07 05:16:00 -0500,2021-01-07,disconnected
2021-01-07 05:18:00 -0500,2021-01-07,connected
2021-01-07 05:20:00 -0500,2021-01-07,connected
2021-01-07 05:20:20 -0500,2021-01-07,connected
2021-01-07 05:22:01 -0500,2021-01-07,connected
```

This tool is stupid simple. I'm just publishing it because it was useful to me and there was no reason not to.
