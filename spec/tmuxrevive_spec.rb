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
      File.should_receive( :open ).with( "~/.tmuxrevive/session.1", 'w' )

      t.save
    end

    it "numbers the session files sequentially from 1"
    it "saves the window title in the session file"
  end

end
