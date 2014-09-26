require 'spec_helper'

describe MojoAuth do
  describe 'create a secret' do
    subject(:secret) { described_class.create_secret }

    it { should be_a String }

    it 'should be long enough' do
      expect(secret.length).to be > 20
    end
  end

  describe 'creating and testing credentials' do
    let(:secret) { described_class.create_secret }

    it 'raises if the secret is not provided' do
      expect { described_class.create_credentials }.to raise_error
    end

    context 'without an asserted ID' do
      let(:credentials) { described_class.create_credentials(secret: secret) }

      describe 'for the generated credentials' do
        it 'tests true' do
          expect(described_class.test_credentials(credentials, secret: secret)).to be true
        end
      end

      describe 'with an incorrect password' do
        it 'tests false' do
          expect(described_class.test_credentials({ username: credentials[:username], password: 'foobar' }, secret: secret)).to be false
        end
      end

      describe 'with a different secret' do
        it 'tests false' do
          expect(described_class.test_credentials(credentials, secret: 'something_else')).to be false
        end
      end

      describe 'after the default TTL (1 day) expires' do
        around do |example|
          credentials # Create the credentials before advancing the time
          Timecop.freeze(Time.now + MojoAuth::DAY_IN_SECONDS + 1) do
            example.run
          end
        end

        it 'tests false' do
          expect(described_class.test_credentials(credentials, secret: secret)).to be false
        end
      end
    end

    context 'with an asserted ID' do
      let(:id) { SecureRandom.uuid }
      let(:credentials) { described_class.create_credentials(id: id, secret: secret) }

      describe 'for the generated credentials' do
        it 'tests truthy, returning the asserted ID' do
          expect(described_class.test_credentials(credentials, secret: secret)).to eql(id)
        end
      end

      describe 'with an incorrect password' do
        it 'tests false' do
          expect(described_class.test_credentials({ username: credentials[:username], password: 'foobar' }, secret: secret)).to be false
        end
      end

      describe 'with a different secret' do
        it 'tests false' do
          expect(described_class.test_credentials(credentials, secret: 'something_else')).to be false
        end
      end

      describe 'after the default TTL (1 day) expires' do
        around do |example|
          credentials # Create the credentials before advancing the time
          Timecop.freeze(Time.now + MojoAuth::DAY_IN_SECONDS + 1) do
            example.run
          end
        end

        it 'tests false' do
          expect(described_class.test_credentials(credentials, secret: secret)).to be false
        end
      end
    end
  end
end
