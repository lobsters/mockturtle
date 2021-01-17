require 'spec_helper'

RSpec.describe Lobstersbot::Tell do
  include described_class

  it 'logs messages' do
    memory = Hash.new
    response = double()
    
    expect(response).to receive(:call).with("I'll pass that along when target is around.")
    on_tell(memory, 'source', 'target message', response)
    expect(memory['target']).to contain_exactly('source: message')
  end
  
  it 'replays messages' do
    memory = {'target' => ['message']}
    response = double()
    
    expect(response).to receive(:call).with('message')
    seen_tell(memory, 'target', response)
  end 
end