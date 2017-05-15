#!/usr/bin/env ruby
require_relative 'lib/notifier'

ignore_fill_seconds = 60 * 60 * 24
poller = Notifier.new(ignore_fill_seconds)
poller.poll
