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
require_relative 'game_options'
require_relative 'version'

module Gemwarrior
  class Repl
    # CONSTANTS
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

    def start(initial_command, extra_command, new_skip, resume_skip)
      setup_screen(initial_command, extra_command, new_skip, resume_skip)

      clocker = Clocker.new

      at_exit do
        update_duration(clocker.stop)
        game.update_options_file
        log_stats(world.duration, world.player)
        save_game(world)
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
      prompt_text = GameOptions.data['debug_mode'] ? ' GW[D]> ' : ' GW> '
      Readline.readline(prompt_text, true).to_s
    end

    def puts(s = '', width = WRAP_WIDTH)
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end

    def print_logo
      puts '/-+-+-+ +-+-+-+-+-+-+-\\'.colorize(:yellow)
      puts '|G|E|M| |W|A|R|R|I|O|R|'.colorize(:yellow)
      puts '\\-+-+-+ +-+-+-+-+-+-+-/'.colorize(:yellow)
      puts '[[[[[[[DEBUGGING]]]]]]]'.colorize(:white) if GameOptions.data['debug_mode']
    end

    def print_splash_message
      SPLASH_MESSAGE.length.times { print '=' }
      puts
      puts SPLASH_MESSAGE
      SPLASH_MESSAGE.length.times { print '=' }
      puts
    end

    def print_fortune
      noun1_values = WordList.new('noun-plural')
      noun2_values = WordList.new('noun-plural')
      noun3_values = WordList.new('noun-plural')

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
      puts " (1) SOUND ENABLED : #{GameOptions.data['sound_enabled']}"
      puts " (2) SOUND VOLUME  : #{GameOptions.data['sound_volume']}"
      puts " (3) USE WORDNIK   : #{GameOptions.data['use_wordnik']}"
      puts
      puts '======================='
      puts
      puts 'Enter option number to change value, or any other key to return to main menu.'
      print 'Option? '
      answer = STDIN.getch

      case answer
      when '1'
        print answer
        GameOptions.data['sound_enabled'] = !GameOptions.data['sound_enabled']
        print_options
      when '2'
        print answer
        print "\n"
        print 'Enter a volume from 0.0 to 1.0: '
        new_vol = gets.chomp.to_f.abs
        if new_vol >= 0.0 and new_vol <= 1.0
          GameOptions.data['sound_volume'] = new_vol
        else
          puts 'Not a valid volume.'
        end
        print_options
      when '3'
        print answer
        GameOptions.data['use_wordnik']= !GameOptions.data['use_wordnik']
        print_options
      else
        print answer
        return
      end
    end

    def display_log_of_attempts
      if File.exist?(GameOptions.data['log_file_path']) and !File.zero?(GameOptions.data['log_file_path'])
        File.open(GameOptions.data['log_file_path']).readlines.each do |line|
          print "#{line}"
        end
        if GameOptions.data['debug_mode']
          print 'Clear log of attempts? (y/n) '
          answer = gets.chomp.downcase

          case answer
          when 'y'
            File.truncate(GameOptions.data['log_file_path'], 0)
            puts 'Log of attempts: erased!'
          end

          puts
        end
      else
        puts 'No attempts made yet!'
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
      puts ' (R)esume Game' if save_file_exist?
      puts ' (A)bout'
      puts ' (H)elp'
      puts ' (O)ptions'
      puts ' (L)og of Attempts'
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
        if overwrite_save?
          clear_screen
          play_intro_tune
          print_splash_message
          print_fortune
          return
        else
          run_main_menu
        end
      when 'r'
        if save_file_exist?
          result = resume_game
          if result.nil?
            run_main_menu
          elsif
            self.world = result
            self.evaluator = Evaluator.new(self.world)
            return
          end
        end
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
        display_log_of_attempts
        run_main_menu
      when 'c'
        puts choice
        check_for_new_release
        run_main_menu
      when 'e', 'x'
        puts choice
        puts MAIN_MENU_QUIT_MESSAGE
        game.update_options_file
        exit
      else
        run_main_menu(show_choices = false)
      end
    end

    def log_stats(duration, pl)
      # display stats upon exit
      puts '######################################################################'
      print 'Gem Warrior'.colorize(color: :white, background: :black)
      print " v#{Gemwarrior::VERSION}".colorize(:yellow)
      print " played for #{duration[:mins].to_s.colorize(color: :white, background: :black)} min(s),"
      print " #{duration[:secs].to_s.colorize(color: :white, background: :black)} sec(s),"
      print " and #{duration[:ms].to_s.colorize(color: :white, background: :black)} ms\n"
      puts  '----------------------------------------------------------------------'
      print "#{pl.name.ljust(10)} killed #{pl.monsters_killed.to_s.colorize(color: :white, background: :black)} monster(s)"
      print "\n".ljust(12)
      print "picked up #{pl.items_taken.to_s.colorize(color: :white, background: :black)} item(s)"
      print "\n".ljust(12)
      print "traveled #{pl.movements_made.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n".ljust(12)
      print "rested #{pl.rests_taken.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n".ljust(12)
      print "died #{pl.deaths.to_s.colorize(color: :white, background: :black)} time(s)"
      print "\n"
      puts '######################################################################'

      # log stats to file in home directory
      File.open(GameOptions.data['log_file_path'], 'a') do |f|
        f.write "#{Time.now} #{pl.name.rjust(10)} - V:#{Gemwarrior::VERSION} LV:#{pl.level} XP:#{pl.xp} $:#{pl.rox} KIL:#{pl.monsters_killed} ITM:#{pl.items_taken} MOV:#{pl.movements_made} RST:#{pl.rests_taken} DTH:#{pl.deaths}\n"
      end
    end

    def save_game(world)
      mode = GameOptions.data['save_file_mode']
      puts 'Saving game...'

      if mode.eql? 'Y'
        File.open(GameOptions.data['save_file_yaml_path'], 'w') do |f|
          f.write YAML::dump(world)
        end
      elsif mode.eql? 'M'
        File.open(GameOptions.data['save_file_bin_path'], 'w') do |f|
          f.write Marshal::dump(world)
        end
      else
        puts 'Error: Save file mode not set. Game not saved.'
        return
      end
      puts 'Game saved!'
    end

    def save_file_exist?
      mode = GameOptions.data['save_file_mode']
      if mode.eql? 'Y'
        File.exist?(GameOptions.data['save_file_yaml_path'])
      elsif mode.eql? 'M'
        File.exist?(GameOptions.data['save_file_bin_path'])
      else
        false
      end
    end
   
    def resume_game
      mode = GameOptions.data['save_file_mode']
      puts 'Resuming game...'

      if mode.eql? 'Y'
        if File.exist?(GameOptions.data['save_file_yaml_path'])
          File.open(GameOptions.data['save_file_yaml_path'], 'r') do |f|
            return YAML::load(f)
          end
        else
          puts 'No save file exists.'
          nil
        end
      elsif mode.eql? 'M'
        if File.exist?(GameOptions.data['save_file_marshal_path'])
          File.open(GameOptions.data['save_file_marshal_path'], 'r') do |f|
            return Marshal::load(f)
          end
        else
          puts 'No save file exists.'
          nil
        end
      end
    end

    def overwrite_save?
      mode = GameOptions.data['save_file_mode']
      save_file_path = ''
      
      if mode.eql? 'Y'
        save_file_path = GameOptions.data['save_file_yaml_path']
      elsif mode.eql? 'M'
        save_file_path = GameOptions.data['save_file_marshal_path']
      end
      
      if File.exist?(save_file_path)
        print 'Overwrite existing save file? (y/n) '
        answer = gets.chomp.downcase
          
        case answer
        when 'y'
          puts 'New game started! Press any key to continue.'
          gets
          return true
        else
          puts 'New game aborted.'
          return false
        end
      end
      true
    end

    def update_duration(new_duration)
      new_mins = new_duration[:mins]
      new_secs = new_duration[:secs]
      new_ms   = new_duration[:ms]

      world.duration[:mins] += new_mins
      world.duration[:secs] += new_secs
      world.duration[:ms]   += new_ms

      if world.duration[:ms] > 1000
        world.duration[:secs] += world.duration[:ms] / 1000
        world.duration[:ms] = world.duration[:ms] % 1000
      end

      if world.duration[:secs] > 60
        world.duration[:mins] += world.duration[:secs] / 60
        world.duration[:secs] = world.duration[:secs] % 60
      end
    end

    def play_intro_tune
      Music::cue([
        { frequencies: 'A3,E4,C#5,E5',  duration: 300 },
        { frequencies: 'A3,E4,C#5,F#5', duration: 600 }
      ])
    end

    def setup_screen(initial_command = nil, extra_command = nil, new_skip = false, resume_skip = false)
      # welcome player to game
      clear_screen
      print_logo

      # main menu loop until new game or exit
      if new_skip
        play_intro_tune
        print_splash_message
        print_fortune
      elsif resume_skip
        result = resume_game
        if result.nil?
          run_main_menu
        elsif
          self.world = result
          self.evaluator = Evaluator.new(self.world)
        end
      else
        run_main_menu
      end

      # hook to do something right off the bat
      puts evaluator.evaluate(initial_command) unless initial_command.nil?
      puts evaluator.evaluate(extra_command) unless extra_command.nil?
    end

    def prompt
      prompt_template = "\n[LV:%2s][XP:%3s][ROX:%3s] [HP:%3s/%-3s][STM:%2s/%-2s] [%s @ %s]"
      if GameOptions.data['debug_mode']
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
      if GameOptions.data['debug_mode']
        prompt_vars_arr.push(world.player.cur_coords[:x], world.player.cur_coords[:y], world.player.cur_coords[:z])
      end
      print (prompt_template % prompt_vars_arr).colorize(:yellow)
      print "\n"
    end

    def command_exists?(cmd)
      ENV['PATH'].split(File::PATH_SEPARATOR).collect { |d| 
        Dir.entries d if Dir.exist? d 
      }.flatten.include?(cmd)
    end
  end
end
