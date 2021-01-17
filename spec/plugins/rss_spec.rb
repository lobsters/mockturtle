require 'spec_helper'

RSpec.describe Lobstersbot::Rss do
  include described_class
  
  it 'requests and posts stories' do
    response = double()
    memory = Hash.new
    
    @config = Hash.new
    @config[:channels] = ['test']
    
    def privmsg(msg, to)
    end
    
    expect(response).to receive(:call).with(nil).and_return(['test'])
    
    frequently_post_stories(memory, response)
    
    expect(memory[:last_run]).to_not be_nil
  end
end