require 'spec_helper'

describe MojoAuth do
  describe 'create a secret' do
    subject(:secret) { described_class.create_secret }

    it { should be_a String }

    it 'should be long enough' do
      expect(secret.length).to be > 20
    end
  end
end
