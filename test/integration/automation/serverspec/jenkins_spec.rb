require 'spec_helper'

describe command('docker ps') do
  its(:stdout) { should match /jenkins/ }
end

describe port(8080) do
  it { should be_listening }
end
