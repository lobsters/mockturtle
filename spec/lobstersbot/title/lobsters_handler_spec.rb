require 'spec_helper'

RSpec.describe Lobstersbot::Title::LobstersHandler do
  subject { Lobstersbot::Title::LobstersHandler.new }

  describe '#handle' do
    it 'returns story details' do
      result = subject.handle({ story: "jg3eet" })
      expect(result).to eq("[Story] Lobsters by mail (via jcs, 33 points, 9 comments)")
    end

    it 'returns comment excerpt' do
      result = subject.handle({ story: "jg3eet", comment: "llnoto" })
      expect(result).to eq(
        "[Comment on https://lobste.rs/s/jg3eet/] Well, lobsters just got a whole hell " +
        "of lot cooler. This will even make it easier to reply on your phone.")
    end
  end
end
