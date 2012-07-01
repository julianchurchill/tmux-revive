require 'aruba/cucumber'

Before do
  @original_home = ENV['HOME']
  ENV['HOME'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../tmp/aruba')}"
  `ln -fs #{@original_home}/.tmux.conf #{ENV['HOME']}`
end

After do
  ENV['HOME'] = @original_home
end
