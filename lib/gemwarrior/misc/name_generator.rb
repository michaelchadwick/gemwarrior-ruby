# lib/gemwarrior/misc/name_generator.rb
# NameGenerator Ruby class (translated from name_generator.js)
# written and released to the public domain by drow <drow@bin.sh>
# http://creativecommons.org/publicdomain/zero/1.0/

require 'yaml'

class NameGenerator
  attr_accessor :name_set, :type, :chain_cache

  def initialize(type)
    self.type         = type
    self.name_set     = get_name_set(self.type)
    self.chain_cache  = {}
  end

  # load sample names
  def get_name_set(type)
    names = []
    names_data = YAML.load_file("data/#{type}_names.yml")
    names_data.each do |n|
      names.push(n)
    end
    return names
  end
  
  # generator function
  def generate_name
    chain = nil

    if (chain = markov_chain(self.type))
      return markov_name(chain)
    end
    
    return ''
  end

  # generate multiple
  def generate_names(count = 1)
    list = []

    for i in 1..count
      list.push(generate_name)
    end
    
    return list
  end

  # get markov chain by type
  def markov_chain(type)
    chain = nil

    if (chain = chain_cache[type])
      return chain
    else
      if (list = name_set)
        chain = nil
        if (chain = construct_chain(list))
          chain_cache[type] = chain
          return chain
        end
      end
    end
    
    return false
  end

  # construct markov chain from list of names
  def construct_chain(list)
    chain = {}

    for i in 0..list.length-1
      names = list[i].split(/\s+/)
      chain = incr_chain(chain, 'parts', names.length)

      for j in 0..names.length-1
        name = names[j].nil? ? [] : names[j]
        chain = incr_chain(chain, 'name_len', name.length)

        c = name[0, 1]
        chain = incr_chain(chain, 'initial', c)

        string = name[1..name.length]
        last_c = c

        while string.length > 0 do
          c = string[0, 1]
          chain = incr_chain(chain, last_c, c)

          string = string[1..string.length]
          last_c = c
        end
      end
    end
    
    return scale_chain(chain)
  end

  def incr_chain(chain, key, token)
    if chain[key]
      if chain[key][token]
        chain[key][token] += 1
      else
        chain[key][token] = 1
      end
    else
      chain[key] = {}
      chain[key][token] = 1
    end
    
    return chain
  end

  def scale_chain(chain)
    table_len = {}

    chain.each do |key, subkey|
      table_len[key] = 0

      subkey.each do |subkey, value|
        count = value
        weighted = (count ** 1.3).floor

        chain[key][subkey] = weighted
        table_len[key] += weighted
      end
    end
    
    chain['table_len'] = table_len

    return chain
  end

  # construct name from markov chain
  def markov_name(chain)
    parts = select_link(chain, 'parts')
    names = []

    for i in 0..parts-1
      name_len = select_link(chain, 'name_len')
      c = select_link(chain, 'initial')
      name = c
      last_c = c

      while name.length < name_len do
        c = select_link(chain, last_c)
        name += c
        last_c = c
      end
      names.push(name)
    end

    return names.join(' ')
  end

  def select_link(chain, key)
    len = chain['table_len'][key]
    idx = (rand() * len).floor

    t = 0
    chain[key].each do |chain_key, chain_value|
      t += chain_value
      return chain_key if (idx < t)
    end
    
    return '-'
  end
end
