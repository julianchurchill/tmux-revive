require_relative '../lib/tmuxrevive'

describe TmuxRevive do

  def tmuxrevive_dir
    ENV['HOME'] + "/.tmuxrevive"
  end

  context "#list" do
    before(:each) do
      @tmuxrevive = TmuxRevive.new
      @tmuxrevive.stub( :puts )
    end

    it "should open the tmuxrevive session directory" do
      Dir.should_receive( :foreach ).with( "#{tmuxrevive_dir}" )

      @tmuxrevive.list
    end

    it "should read all the available sessions from the sessions directory" do
      Dir.stub( :foreach ).and_yield( "session.1" ).and_yield( "session.2" )
      file = double( "session file" )
      File.should_receive( :open ).with( "#{tmuxrevive_dir}/session.1" ).and_yield( file )
      file.should_receive( :read )
      file2 = double( "session file" )
      File.should_receive( :open ).with( "#{tmuxrevive_dir}/session.2" ).and_yield( file2 )
      file2.should_receive( :read )

      @tmuxrevive.list
    end

    it "should only print the list of available session titles" do
      Dir.stub( :foreach ).and_yield( "nonsession" ).and_yield( "session.1" ).and_yield( "session.2" )
      File.stub( :open )
      @tmuxrevive.should_receive( :puts ).with( /\Asession 1:\n.*?session 2:\n.*?\Z/ )

      @tmuxrevive.list
    end

    it "should print the list of available session titles in ascending numerical order"

    it "should print the session properties" do
      Dir.stub( :foreach ).and_yield( "session.1" ).and_yield( "session.2" )
      file = double( "session file" )
      file.stub( :read ).and_return( "window_title george" )
      File.stub( :open ).with( "#{tmuxrevive_dir}/session.1" ).and_yield( file )
      file2 = double( "session file" )
      file2.stub( :read ).and_return( "window_title mavis" )
      File.stub( :open ).with( "#{tmuxrevive_dir}/session.2" ).and_yield( file2 )
      @tmuxrevive.should_receive( :puts ).with( /\A.*\n    window_title george\n.*\n    window_title mavis\n\Z/ )

      @tmuxrevive.list
    end
  end

  context "#restore" do
    before(:each) do
      @tmuxrevive = TmuxRevive.new
      @tmuxrevive.stub( :'`' )
      @window_title = "trevor"
      file = double( "session file" )
      file.stub( :read ).and_return( "window_title #{@window_title}" )
      File.stub( :open ).and_yield( file )
    end

    it "reads the session file indexed by the session id argument" do
      File.should_receive( :open ).with( /#{ENV['HOME']}\/\.tmuxrevive\/session\.123/, 'r' )
      @tmuxrevive.restore 123
    end

    it "starts a new detached tmux session" do
      @tmuxrevive.should_receive( :'`' ).with( /^TMUX= tmux new-session -d/ )
      @tmuxrevive.restore 123
    end

    it "sets the window title from the session file" do
      @tmuxrevive.should_receive( :'`' ).with( / -n #{@window_title} \;$/ )
      @tmuxrevive.restore 123
    end
  end

  context "#save" do
    before(:each) do
      @tmuxrevive = TmuxRevive.new
      @tmuxrevive.stub( :'`' ).with( "tmux list-windows" ).and_return( "1: luther [123x456] [layout bfde,123x45,0,] (active)" )
      Dir.stub( :exists? )
      Dir.stub( :mkdir )
      Dir.stub( :foreach )
      File.stub( :open )
    end

    it "does not accept arguments" do
      @tmuxrevive.should_receive( :exit ).with( "save does not accept any arguments")

      @tmuxrevive.save 123
    end

    it "creates the .tmuxrevive directory if it doesn't exist" do
      Dir.should_receive( :mkdir ).with( "#{ENV['HOME']}/.tmuxrevive" )

      @tmuxrevive.save
    end

    it "does not create the .tmuxrevive directory if it already exists" do
      Dir.should_receive( :exists? ).with( "#{ENV['HOME']}/.tmuxrevive" ).and_return( true )
      Dir.should_not_receive( :mkdir )

      @tmuxrevive.save
    end

    it "saves the session in a numbered file in the .tmuxrevive directory" do
      File.should_receive( :open ).with( /#{ENV['HOME']}\/\.tmuxrevive\/session\.[\d]/, 'w' )

      @tmuxrevive.save
    end

    it "numbers the session files sequentially from 1" do
      File.should_receive( :open ).with( /\.1$/, 'w' )
      @tmuxrevive.save

      Dir.stub( :foreach ).and_yield( "session.1" )
      File.should_receive( :open ).with( /\.2$/, 'w' )
      @tmuxrevive.save

      Dir.stub( :foreach ).and_yield( "session.1" ).and_yield( "session.2" )
      File.should_receive( :open ).with( /\.3$/, 'w' )
      @tmuxrevive.save
    end

    it "numbers the session files sequentially after the highest numbered saved session" do
      Dir.should_receive( :foreach ).with( "#{ENV['HOME']}/.tmuxrevive" ).and_yield( "session.4" ).and_yield( "session.2" )
      File.should_receive( :open ).with( /\.5$/, 'w' )

      @tmuxrevive.save
    end

    it "retrieves a window list from tmux" do
      @tmuxrevive.should_receive( :'`' ).with( "tmux list-windows" )
      @tmuxrevive.save
    end

    it "stores the window title in the session file" do
      file = double('session file')
      File.stub( :open ).and_yield( file )
      file.should_receive( :write ).with( "window_title luther" )

      @tmuxrevive.save
    end
  end

end
