require 'aruba/cucumber'

Before do
  @original_home = ENV['HOME']
  ENV['HOME'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../tmp/aruba')}"
  # tmp/aruba doesn't get created till later but we need to set it up now...
  Dir.mkdir( ENV['HOME'][/(.*?)\/aruba/, 1 ] ) unless Dir.exists? ENV['HOME'][/(.*?)\/aruba/, 1 ]
  Dir.mkdir( ENV['HOME'] ) unless Dir.exists? ENV['HOME']
  `ln -fs #{@original_home}/.tmux.conf #{ENV['HOME']}/`
end

After do
  ENV['HOME'] = @original_home
end
