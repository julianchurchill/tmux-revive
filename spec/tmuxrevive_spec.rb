require_relative '../lib/tmuxrevive'

describe TmuxRevive do

  context "#save" do
    it "creates the .tmuxrevive directory if it doesn't exist" do
      t = TmuxRevive.new
      Dir.should_receive( :mkdir ).with( "~/.tmuxrevive" )
      File.stub( :open )

      t.save
    end

    it "saves the session in a numbered file in the .tmuxrevive directory" do
      t = TmuxRevive.new
      Dir.stub( :mkdir )
      File.should_receive( :open ).with( /~\/\.tmuxrevive\/session\.[\d]/, 'w' )

      t.save
    end

    it "numbers the session files sequentially from 1" do
      t = TmuxRevive.new
      Dir.stub( :mkdir )
      File.should_receive( :open ).with( /\.1$/, 'w' )
      t.save

      File.should_receive( :open ).with( /\.2$/, 'w' )
      t.save

      File.should_receive( :open ).with( /\.3$/, 'w' )
      t.save
    end

    it "numbers the session files sequentially after the last saved session"
    it "saves the window title in the session file"
  end

end
