# lib/gemwarrior/misc/timer.rb
# Timer

require 'observer'

module Gemwarrior
  class Timer
    include Observable

    attr_accessor :duration_in_s, :timer_name, :background, :progress, :verbose, :command

    DEFAULTS = {
      duration_in_s: 5, 
      timer_name:    'timer', 
      background:    true,
      progress:      false,
      verbose:       false,
      command:       nil
    }

    def initialize(options = {}, repl)
      options = DEFAULTS.merge(options)

      self.duration_in_s  = options[:duration_in_s]
      self.timer_name     = options[:timer_name]
      self.background     = options[:background]
      self.progress       = options[:progress]
      self.verbose        = options[:verbose]
      self.command        = options[:command]

      add_observer(repl)
    end

    def start
      if background
        Thread.start { self.run }
      else
        self.run
      end
    end

    def run
      puts "#{timer_name} began at #{Time.now} for #{duration_in_s} seconds" if verbose

      end_time = Time.now + duration_in_s

      loop do
        sleep 1
        print '.' if progress
        if Time.now >= end_time
          return stop
        end
      end
    end

    def stop
      puts "\n#{timer_name} ended at #{Time.now}" if verbose
      changed
      notify_observers(self.command) unless self.command.nil?
    end
  end
end
