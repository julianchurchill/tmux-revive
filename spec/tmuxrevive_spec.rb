require_relative '../lib/tmuxrevive'

describe TmuxRevive do

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

    it "starts a new tmux session" do
      @tmuxrevive.should_receive( :'`' ).with( /^TMUX= tmux new-session/ )
      @tmuxrevive.restore 123
    end

    it "sets the window title from the session file" do
      @tmuxrevive.should_receive( :'`' ).with( / -n #{@window_title}$/ )
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
