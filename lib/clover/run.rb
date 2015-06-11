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
  end

  def render_skips
  end
end
