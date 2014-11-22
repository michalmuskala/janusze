# Adds sane Enumerable method aliases
module Enumerable
  # aliasing Enumerable.lazy methods doesn't seem to work. Why?
    # alias_method :fold, :reduce

  # Alias for <tt>Enumerable#reduce</tt>
  def fold(*args, &block)
    reduce(*args, &block)
  end

  # Alias for <tt>Enumerable#select</tt>
  def filter(*args, &block)
    select(*args, &block)
  end

  def without(*args)
    select { |x| !args.include?(x) }
  end
end

# <tt>Enumerable#zip</tt> as a free function in a rare case you would need it to do it like <tt>zip(a,b)</tt> instead of <tt>a.zip(b)</tt>
def self.zip(a, *as)
  a.zip(*as)
end

module ExtractAsHash
  # Extracts elements from hash given as an array (can be splatted.
  # When +map_names+ option is specified it maps of attributes in resulting hash.
  # The mapping can be immediate or a can be a proc that is evaluated with key name as symbol.
  # It's return valuecan be any of +mapped_name+, +[nil, mapped_value]+, +[mapped_name, mapped_value]+
  # which maps to the resultant hash attribute name and value respectively.
  def extract_as_hash(*attribs, map_names:{})
    (attribs = attribs[0]) if attribs.count == 1 && attribs[0].is_a?(Array)

    Hash[attribs.map do |attr|
      attr_val = self.send(attr)

      if map_to = map_names[attr] then
        if map_to.is_a? Proc then
          mapped_name, mapped_val = case map_to.parameters.count
            when 0
              map_to.call
            when 1
              map_to.call(attr)
            when 2
              map_to.call(attr, attr_val)
          end
        else
          mapped_name = map_to
        end
      end

      attr_name = mapped_name || attr
      attr_val = mapped_val || attr_val

      [attr_name, attr_val]
    end]
  end
end

class Hash
  # Get a value in a nested hash defaulting to <tt>default</tt> or <tt>nil</tt> if not specified.
  # Short-circuits if any part of path is non-existent.
  def get_path(*path, default: nil)
    path.fold(self) do |hash, key|
      if res = hash[key] then
        res
      else
        return default
      end
    end
  end

  # hash with removed keys, toplevel only
  # TODO: fix it to work with indifferent-access hashes
  def without(*keys)
    Hash[self.map do |key, val|
      [key, val] unless keys.include?(key)
    end.filter(&:present?)]
  end

  # dual to above; works for indifferent-access hashes as well
  # order of picking is persisted sans nonexistent keys
  def pick(*keys)
    Hash[keys.map { |key| [key, self[key]] }.filter(&:present?)]
  end

  # flattens a hash sensibly to one lvl hash
  def hash_flatten(separator='_')
    flat_hash = {}

    helper = Proc.new do |lead_key, hash|
      hash.each do |key, val|
        new_key = (Array.wrap(lead_key) + [key]).map(&:to_s).join(separator).to_sym

        if !val.is_a?(Hash) then
          flat_hash[new_key] = val
        else
          helper.call(new_key, val)
        end
      end
    end

    helper.call([], self)

    flat_hash
  end
end

class Class
  def to_sym
    to_s.to_sym
  end
end

Object.send(:include, ExtractAsHash)

# For more readable infinite ranges
INF = 1.0/0

if Rails.env.development?
  module LoggerForceDebugLevel
    def level=(x)
      # binding.pry
      # super(x)
      super(0) # :debug
    end
  end

  Logger.prepend(LoggerForceDebugLevel)
end
