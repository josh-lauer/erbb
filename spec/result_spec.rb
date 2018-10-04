RSpec.describe ERBB::Result do
  describe '#initialize' do
    it 'saves second argument as named_blocks' do
      named_blocks = { foo: 'bar' }
      result = ERBB::Result.new('', named_blocks)

      expect(result.named_blocks).to eq(named_blocks)
    end

    it 'symbolizes the keys in named_blocks' do
      named_blocks = { foo: 'bar', 'biz' => 'baz'}
      result = ERBB::Result.new('', named_blocks)

      expect(result.named_blocks).to eq({ foo: 'bar', biz: 'baz'})
    end
  end

  describe '#method_missing' do
    it 'delegates method_missing calls to the named_blocks hash' do
      named_blocks = { foo: 'bar' }
      result = ERBB::Result.new('', named_blocks)

      expect(result.foo).to eq('bar')
    end

    it 'errors as expected if calling undefined methods' do
      named_blocks = { foo: 'bar' }
      result = ERBB::Result.new('', named_blocks)

      expect { result.bar }.to raise_error(NoMethodError)
    end

    it 'calls the string method if there is a collision with named_blocks' do
      named_blocks = { to_s: 'bar' }
      result = ERBB::Result.new('string contents',{to_s: 'bar'})

      expect(result.to_s).to eq('string contents')
    end
  end
end