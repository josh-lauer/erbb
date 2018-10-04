RSpec.describe ERBB::Parser do
  describe '#initialize' do
    it 'raises if an eoutvar is provided' do
      expect { ERBB::Parser.new('foo', nil, nil, 'some_eoutvar_value') }.to raise_error(ArgumentError)
    end
  end

  describe '#result' do
    context 'without named blocks' do
      let(:erbb) { ERBB::Parser.new(template) }
      let(:template) { %q{<%= "foo" %> bar} }

      it 'returns an ERBB::Result with no named blocks on it' do
        result = erbb.result(binding)

        expect(result).to be_a(ERBB::Result)
        expect(result.named_blocks).to eq({})
      end

      it 'correctly renders erb' do
        result = erbb.result(binding)

        expect(result).to eq('foo bar')
      end
    end

    context 'with named blocks' do
      let(:result) { erbb.result(binding) }
      let(:erbb) { ERBB::Parser.new(template) }
      let(:template) do
<<-TEMPLATE
<%= "line of text 1\n" %>
<% named_block :block_1 do %>
line of text 2
<% end %>
line of text 3
<% named_block :block_2 do %>
line of text 4
<% named_block :block_3 do %>
line of text 5
<% end %>
line of text 6
<% end %>
<% named_block :block_3 do %>
line of text 7
<% end %>
TEMPLATE
      end

      it 'returns an ERBB::Result with named blocks on it' do
        expect(result).to be_a(ERBB::Result)
        expect(result.named_blocks).to be_a(Hash)
        expect(result.named_blocks).to_not be_empty
      end

      it 'renders erb with nested named blocks' do
        expected = (1..7).map{|n| "line of text #{n}" }.join("\n") + "\n"

        expect(result).to eq(expected)
      end

      it 'renders and saves named block output on nested block templates' do
        expected = {
          # a non-nested named block
          :block_1 => "line of text 2\n",
          # a named block with a named block nested inside it
          :block_2 => "line of text 4\nline of text 5\nline of text 6\n",
          # a block name that was invoked twice and concatenated
          :block_3 => "line of text 5\nline of text 7\n"
        }

        expect(result.named_blocks).to eq(expected)
      end
    end
  end
end