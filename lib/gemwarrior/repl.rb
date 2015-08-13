# lib/gemwarrior/repl.rb
# My own, simple, Read Evaluate Print Loop module

require 'readline'
require 'os'
require 'clocker'
require 'io/console'
require 'github_api'

require_relative 'misc/timer'
require_relative 'misc/wordlist'
require_relative 'evaluator'
require_relative 'version'

module Gemwarrior
  class Repl
    # CONSTANTS
    ## MESSAGES
    QUIT_MESSAGE            = 'Temporal flux detected. Shutting down...'.colorize(:red)
    MAIN_MENU_QUIT_MESSAGE  = 'Giving up so soon? Jool will be waiting...'.colorize(:yellow)
    SPLASH_MESSAGE          = 'Welcome to *Jool*, where randomized fortune is just as likely as mayhem.'
    WRAP_WIDTH              = 80
    GITHUB_NAME             = 'michaelchadwick'
    GITHUB_PROJECT          = 'gemwarrior'

    attr_accessor :game, :world, :evaluator

    def initialize(game, world, evaluator)
      self.game         = game
      self.world        = world
      self.evaluator    = evaluator
    end

    def start(initial_command = nil, extra_command = nil)
      setup_screen(initial_command, extra_command)

      clocker = Clocker.new

      at_exit do
        pl = world.player
        duration = clocker.stop
        game.update_options_file(world)
        log_stats(duration, pl)
      end

      clocker.clock do
        # main loop
        loop do
          prompt
          begin
            input = read_line
            result = evaluator.evaluate(input)
            if result.eql?('exit')
              exit
            else
              puts result
            end
          rescue Interrupt
            puts
            puts QUIT_MESSAGE
            exit
          end
        end
      end
    end

    private

    def clear_screen
      OS.windows? ? system('cls') : system('clear')
    end

    def read_line
      prompt_text = world.debug_mode ? ' GW[D]> ' : ' GW> '
      Readline.readline(prompt_text, true).to_s
    end

    def puts(s = '', width = WRAP_WIDTH)
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end

    def print_logo
      puts '/-+-+-+ +-+-+-+-+-+-+-\\'.colorize(:yellow)
      puts '|G|E|M| |W|A|R|R|I|O|R|'.colorize(:yellow)
      puts '\\-+-+-+ +-+-+-+-+-+-+-/'.colorize(:yellow)
      puts '[[[[[[[DEBUGGING]]]]]]]'.colorize(:white) if world.debug_mode
    end

    def print_splash_message
      SPLASH_MESSAGE.length.times { print '=' }
      puts
      puts SPLASH_MESSAGE
      SPLASH_MESSAGE.length.times { print '=' }
      puts
    end

    def print_fortune
      noun1_values = WordList.new(world.use_wordnik, 'noun-plural')
      noun2_values = WordList.new(world.use_wordnik, 'noun-plural')
      noun3_values = WordList.new(world.use_wordnik, 'noun-plural')

      puts "* Remember: #{noun1_values.get_random_value} and #{noun2_values.get_random_value} are the key to #{noun3_values.get_random_value} *\n\n"
      puts
    end

    def print_about_text
      puts 'Gem Warrior - A Game of Fortune and Mayhem'.colorize(:yellow)
      puts '=========================================='.colorize(:yellow)
      puts 'Gem Warrior is a text adventure roguelike-lite as a RubyGem created by Michael Chadwick (mike@codana.me) and released as open-source on Github. Take on the task set by Queen Ruby to defeat the evil Emerald and get back the ShinyThing(tm) he stole for terrible, dastardly reasons.'
      puts
      puts 'Explore the land of Jool with the power of text, fighting enemies to improve your station, grabbing curious items that may or may not come in handy, and finally defeating Mr. Emerald himself to win the game.'
    end

    def print_help_text
      puts 'Gem Warrior - Some Basic Help Commands'.colorize(:yellow)
      puts '======================================'.colorize(:yellow)
      puts '* Basic functions: look, go, character, inventory, attack *'
      puts '* Type \'help\' while in-game for complete list of commands *'
      puts '* Most commands can be abbreviated to their first letter  *'
    end

    def print_options
      puts
      puts 'Gem Warrior Options'.colorize(:yellow)
      puts '======================='.colorize(:yellow)
      puts 'Toggle whether sound is played, what the game\'s volume is, or whether Wordnik is used to generate more dynamic descriptors of entities (valid WORDNIK_API_KEY environment variable must be set)'
      puts
      puts " (1) SOUND ENABLED : #{world.sound_enabled}"
      puts " (2) SOUND VOLUME  : #{world.sound_volume}"
      puts " (3) USE WORDNIK   : #{world.use_wordnik}"
      puts
      puts '======================='
      puts
      puts 'Enter option number to change value, or any other key to return to main menu.'
      print 'Option? '
      answer = STDIN.getch

      case answer
      when '1'
        print answer
        world.sound_enabled = !world.sound_enabled
        print_options
      when '2'
        print answer
        print "\n"
        print 'Enter a volume from 0.0 to 1.0: '
        new_vol = gets.chomp.to_f.abs
        if new_vol >= 0.0 and new_vol <= 1.0
          world.sound_volume = new_vol
        else
          puts 'Not a valid volume.'
        end
        print_options
      when '3'
        print answer
        world.use_wordnik = !world.use_wordnik
        print_options
      else
        print answer
        return
      end
    end

    def display_log
      if File.exist?(game.get_log_file_path)
        File.open(game.get_log_file_path).readlines.each do |line|
          print "#{line}"
        end
        puts
      else
        puts 'No attempts made yet!'
        puts
      end
    end

    def check_for_new_release
      puts 'Checking releases...'
      github = Github.new
      gw_latest_release = github.repos.releases.list GITHUB_NAME, GITHUB_PROJECT
      local_release = Gemwarrior::VERSION
      remote_release = gw_latest_release[0].tag_name
      remote_release[0] = ''
      if remote_release > local_release
        puts "GW v#{remote_release} available! Please (E)xit and run 'gem update' before continuing."
        puts
      else
        puts 'You have the latest version. Fantastic!'
        puts
      end
    end

    def print_main_menu
      puts
      puts "      GW v#{Gemwarrior::VERSION}"
      puts '======================='
      puts ' (N)ew Game'
      puts ' (A)bout'
      puts ' (H)elp'
      puts ' (O)ptions'
      puts ' (L)og'
      puts ' (C)heck for Updates'
      puts ' (E)xit'
      puts '======================='
      puts
    end

    def print_main_menu_prompt
      print '> '
    end

    def run_main_menu(show_choices = true)
      print_main_menu if show_choices
      print_main_menu_prompt if show_choices

      choice = STDIN.getch.downcase

      case choice
      when 'n'
        clear_screen
        play_intro_tune
        print_splash_message
        print_fortune
        return
      when 'a'
        puts choice
        print_about_text
        run_main_menu
      when 'h'
        puts choice
        print_help_text
        run_main_menu
      when 'o'
        puts choice
        print_options
        run_main_menu
      when 'l'
        puts choice
        display_log
        run_main_menu
      when 'c'
        puts choice
        check_for_new_release
        run_main_menu
      when 'e', 'x'
        puts choice
        puts MAIN_MENU_QUIT_MESSAGE
        game.update_options_file(world)
        exit
      else
        run_main_menu(show_choices = false)
      end
    end

    def log_stats(duration, pl)
      puts '######################################################################'
      print 'Gem Warrior'.colorize(color: :white, background: :black)
      print " v#{Gemwarrior::VERSION}".colorize(:yellow)
      print " played for #{duration[:mins].to_s.colorize(color: :white, background: :black)} mins, #{duration[:secs].to_s.colorize(color: :white, background: :black)} secs, and #{duration[:ms].to_s.colorize(color: :white, background: :black)} ms\n"
      puts  '----------------------------------------------------------------------'
      print "Player killed #{pl.monsters_killed.to_s.colorize(color: :white, background: :black)} monster(s)"
      print "\n".ljust(8)
      print "picked up #{pl.items_taken.to_s.colorize(color: :white, background: :black)} item(s)"
      print "\n".ljust(8)
      print "traveled #{pl.movements_made.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n".ljust(8)
      print "rested #{pl.rests_taken.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n".ljust(8)
      print "died #{pl.deaths.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n"
      puts '######################################################################'

      # log stats to file in home directory
      File.open(game.get_log_file_path, 'a') do |f|
        f.write "#{Time.now} #{pl.name.rjust(10)} - V:#{Gemwarrior::VERSION} LV:#{pl.level} XP:#{pl.xp} $:#{pl.rox} KIL:#{pl.monsters_killed} ITM:#{pl.items_taken} MOV:#{pl.movements_made} RST:#{pl.rests_taken} DTH:#{pl.deaths}\n"
      end
    end

    def play_intro_tune
      if world.sound_enabled
        Music::cue([
          { frequencies: 'A3,E4,C#5,E5',  duration: 300 },
          { frequencies: 'A3,E4,C#5,F#5', duration: 600 }
        ], world.sound_volume)
      end
    end

    def setup_screen(initial_command = nil, extra_command = nil)
      # welcome player to game
      clear_screen
      print_logo

      # main menu loop until new game or exit
      if world.new_game
        play_intro_tune
        print_splash_message
        print_fortune
      else
        run_main_menu
      end

      # hook to do something right off the bat
      puts evaluator.evaluate(initial_command) unless initial_command.nil?
      puts evaluator.evaluate(extra_command) unless extra_command.nil?
    end

    def prompt
      prompt_template = "\n[LV:%2s][XP:%3s][ROX:%3s] [HP:%3s/%-3s][STM:%2s/%-2s] [%s @ %s]"
      if world.debug_mode
        prompt_template += "[%s, %s, %s]"
      end
      prompt_vars_arr = [
        world.player.level,
        world.player.xp,
        world.player.rox,
        world.player.hp_cur,
        world.player.hp_max,
        world.player.stam_cur,
        world.player.stam_max,
        world.player.name,
        world.location_by_coords(world.player.cur_coords).name
      ]
      if world.debug_mode
        prompt_vars_arr.push(world.player.cur_coords[:x], world.player.cur_coords[:y], world.player.cur_coords[:z])
      end
      print (prompt_template % prompt_vars_arr).colorize(:yellow)
      print "\n"
    end
  end
end
