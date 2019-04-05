# Fubby

Fubby is a collection of functional concepts written from first principles in
ruby.

The library can be used as a gem however it is not advised for production use.

This project is academic and prioritizes a very particular coding style over
performance and readability. As an example here is a function that
performs the same role as ruby's [`all?`](https://apidock.com/ruby/Enumerable/all%3F)

```ruby
  def f_all
    C.curry.(
      ->(f, xs) {
        !any.(->(x) { x == false }, map.(f, xs))
      }
    )
  end
```

There are a lot of inefficiencies here. For starters every function call in this
library uses the `lambda` syntax: `->(...) { }`. This leads to a "double"
declaration of every function as the `def <method_name>` is only used as a
wrapper to help organize code. Ignoring the `def f_all` and the `C.curry` lines
we are left with:

```ruby
  ->(f, xs) {
    !any.(->(x) { x == false }, map.(f, xs))
  }
```

Unwrapping this further we find both `any` and `map` are implemented in terms of
a implementation of `reduce`. Writing all the code out would be confusing to
read so I'll stop here, you can read the code further if you want to understand
it. This should highlight why this code is not a good candidate for anything
other than furthering your understanding of ruby and functional concepts. The
main reasons are:

1. It is not performant. An optimized `all` implementation would be able to
short circuit when a value does not satisfy the checking function.
2. All the iteration is recursive and there are many passes over the same
collection to arrive at the result.
3. There are a ton of closures. For something as straightforward as `all` there
is a lot of space overhead required to keep all the calling contexts in scope.
4. There is no type checker. For most of the code to work in this library you
need to manually ensure the contracts between functions are correct. Ruby isn't
going to help here so there is a lot of mental gymnastics required to figure out
if you are calling everything correctly. Honestly even if ruby could help I'd be
impressed if you still didn't have a hard time. I struggle to get my head back
into how this is all written whenever I re-visit it...

## What should I do with this code?

Read it! Then think about how you would write the same thing. Or even better, go
ahead and try and write some of this yourself. I've tried to stick to
conventions for naming and comments so searching for particular terms or
function names will yield a lot more reading on anything I've written here.

## License

[MIT](https://github.com/RichardLitt/standard-readme/blob/master/LICENSE)
