namespace :server do
  task :run do
    IO.popen(%q(bundle exec rerun \
    -d app/controllers \
    -d app/services \
    -d db/ \
    -d ./ \
    -p "**/*.{rb,ru}" \
    -- \
    puma -p 8000 config.ru
    )) do |output|
      output.each do |line|
        puts line
      end
    end
  end
end