module Clover
  def progress
    @progress ||= TTY::ProgressBar.new ':current of :total [:bar]' do |cfg|
      cfg.total = units.map {|u| u.tests.size}.reduce(:+) || 0
      cfg.width = TTY::Screen.width
      cfg.complete = '.'
    end
  end

  def run pattern_or_files = DEFAULT_PATTERN
    load_files(pattern_or_files)
    units.shuffle.each do |unit|
      # exceptions raised inside unit#__run__ will be treated as failures and pretty printed.
      # any other exceptions will be treated as implementation errors and ugly printed.
      unit.tests.keys.shuffle.each do |test|
        status = unit.run(test)
        if status.is_a?(Skip)
          skips << status
        else
          status == :__clover_passed__ || render_failure(unit, unit.tests[test], status)
        end
        progress.advance
      end
    end
    render_skips
    progress.log ''
  end

  def render_failure unit, test_uuid, failure
    indent = ''
    [*unit.__ancestors__, unit].each do |u|
      progress.log indent + u.__identity__
      indent << INDENT
    end
    progress.log indent + test_uuid
    indent << INDENT
    case failure
    when Exception
      render_exception(indent, failure)
    when AssertionFailure
      render_assertion_failure(indent, failure)
    when GenericFailure
      render_generic_failure(indent, failure)
    else
      progress.log(indent + failure.inspect)
    end
    progress.log ''
  end

  def render_exception indent, failure
    progress.log indent + underline.bright_red(failure.message)
    pretty_backtrace(failure).each {|l| progress.log(indent + l)}
  end

  def render_assertion_failure indent, failure
    require 'clover/pretty_print'
    render_caller(indent, failure.caller)
    progress.log indent + cyan('a: ') + pp(failure.object)
    progress.log indent + cyan('b: ') + failure.arguments.map {|a| pp(a)}.join(', ')
  end

  def render_generic_failure indent, failure
    render_caller(indent, failure.caller)
    failure.reason.each {|l| progress.log indent + underline.bright_red(l)}
  end

  def render_caller indent, caller
    return unless caller
    progress.log indent + underline.bright_red(readline(caller))
  end

  def render_skips
    return if skips.empty?
    progress.log ''
    progress.log bold.magenta('Skips:')
    skips.each do |skip|
      progress.log '  %s (%s)' % [blue(skip.reason || 'skip'), relative_location(skip.caller)]
    end
  end
end
