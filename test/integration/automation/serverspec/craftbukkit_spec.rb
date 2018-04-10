require 'spec_helper'

describe command('docker ps') do
  its(:stdout) { should match /craftbukkit/ }
end

describe port(25565) do
  it { should be_listening }
end
