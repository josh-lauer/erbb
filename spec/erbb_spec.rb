RSpec.describe ERBB do
  it "has a version number" do
    expect(ERBB::VERSION).to eq('0.1.0')
  end

  describe '#new' do
    it 'constructs an ERBB::Parser' do
      parser_args = [double,double,double,double]
      expect(ERBB::Parser).to receive(:new).with(*parser_args)
      ERBB.new(*parser_args)
    end
  end
end