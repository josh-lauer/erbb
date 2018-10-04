[![Build Status](https://travis-ci.com/josh-lauer/erbb.svg?branch=master)](https://travis-ci.com/josh-lauer/erbb)

# ERBB

`ERBB` is `ERB`, with the additional ability to name blocks and save the output of rendering those blocks separately. It works exactly like `ERB`, with some additional methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'erbb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install erbb

## Usage

`ERBB` is built on top of `ERB`. It implements a `#named_block` method in templates which tells the parser to save the rendered contents of the block. In every other way, `ERBB` is used the same way as `ERB`.

First, set up your erb template and instantiate.

```ruby
template = <<~TEMPLATE
             some text
             <% named_block :foo do %>
             some text in the named block
             <% end %>
             some more text
           TEMPLATE

erbb = ERBB.new(template)
```
Then call `#result` to get the rendered output

```ruby
result = erbb.result(binding)
=> "some text\nsome text in the named block\nsome more text\n"
```
The result is a string-like object that has a `#named_blocks` method that returns the rendered contents of all the named blocks in the template.

```ruby
result.named_blocks
=> {:foo=>"some text in the named block\n"}
```

Also, for convenience, the result delegates method calls to `#named_blocks` if they don't collide with String methods

```ruby
result.foo
=> "some text in the named block\n"
```
That's pretty much it. Use it like `ERB`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/josh-lauer/erbb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
