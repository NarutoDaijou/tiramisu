module Clover
  def identity_string type, label, block
    '%s %s (%s:%s)' % [
      blue(type),
      label.inspect,
      *relative_source_location(block)
    ]
  end

  def relative_source_location block
    [
      relative_location(block.source_location[0]),
      block.source_location[1]
    ]
  end

  def relative_location line
    line.sub(/\A#{pwd}\/+/, '')
  end

  def pretty_backtrace e
    Array(e.backtrace).dup.select! {|l| l =~ /\A#{pwd}/}.map! {|l| relative_location(l)}
  end

  def readline caller
    file, line = caller.split(/:(\d+):in.+/)
    return unless file && line
    lines = ((@__readlinecache__ ||= {})[file] ||= File.readlines(file))
    return unless line = lines[line.to_i - 1]
    line.sub(/(do|\{)\Z/, '').strip
  end

  def load_files pattern_or_files
    files = pattern_or_files.is_a?(Array) ? pattern_or_files : Dir[pwd(pattern_or_files)]
    files.each {|f| load_file(f)}
  end

  def load_file file
    augment_load_path(file)
    require(file)
  end

  def augment_load_path file
    # adding ./
    $:.unshift(pwd) unless $:.include?(pwd)

    # adding ./lib/
    lib = pwd('lib')
    unless $:.include?(lib)
      $:.unshift(lib) if File.directory?(lib)
    end

    # adding file's dirname
    dir = File.dirname(file)
    $:.unshift(dir) unless $:.include?(dir)
  end

  def pwd *args
    File.join(Dir.pwd, *args.map!(&:to_s))
  end
end
