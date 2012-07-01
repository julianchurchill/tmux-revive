require_relative '../lib/tmuxrevive'

describe TmuxRevive do

  context "#save" do
    before(:each) do
      @tmuxrevive = TmuxRevive.new
      Dir.stub( :mkdir )
      Dir.stub( :foreach )
      File.stub( :open )
    end

    it "creates the .tmuxrevive directory if it doesn't exist" do
      Dir.should_receive( :mkdir ).with( "~/.tmuxrevive" )

      @tmuxrevive.save
    end

    it "saves the session in a numbered file in the .tmuxrevive directory" do
      File.should_receive( :open ).with( /~\/\.tmuxrevive\/session\.[\d]/, 'w' )

      @tmuxrevive.save
    end

    it "numbers the session files sequentially from 1" do
      File.should_receive( :open ).with( /\.1$/, 'w' )
      @tmuxrevive.save

      Dir.stub( :foreach ).with( "~/.tmuxrevive" ).and_yield( "session.1" )
      File.should_receive( :open ).with( /\.2$/, 'w' )
      @tmuxrevive.save

      Dir.stub( :foreach ).with( "~/.tmuxrevive" ).and_yield( "session.1" ).and_yield( "session.2" )
      File.should_receive( :open ).with( /\.3$/, 'w' )
      @tmuxrevive.save
    end

    it "numbers the session files sequentially after the highest numbered saved session" do
      Dir.should_receive( :foreach ).with( "~/.tmuxrevive" ).and_yield( "session.4" ).and_yield( "session.2" )
      File.should_receive( :open ).with( /\.5$/, 'w' )

      @tmuxrevive.save
    end

    it "saves the window title in the session file"
  end

end
