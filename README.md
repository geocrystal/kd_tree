# Kd::Tree

Crystal implementation of "K-Dimensional Tree" and "N-Nearest Neighbors"
based on http://en.wikipedia.org/wiki/Kd-tree.


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kdtree:
    github: mamantoha/kd_tree
```

## Usage

```crystal
require "kd_tree"
```

Construct a new tree. Each point should be of the form `[x, y]`, where `x` and `y` are floats:

```crystall
kd = Kd::Tree.new(points)
```

Find the nearest point to `[x, y]`. Returns an array with one point:

```crystal
kd.nearest([x, y])
```

Find the nearest `k` points to `[x, y]`. Returns an array of points:

```crystal
kd.nearest([x, y], k)
```

## Contributing

1. Fork it (<https://github.com/mamantoha/kd_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mamantoha](https://github.com/mamantoha) Anton Maminov - creator, maintainer
