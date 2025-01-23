# Nanosleep

This is a gem that wraps the `nanosleep` system call so you can sleep for
a certain amount of time, but it also gives you control over whether or not
the GVL is held during sleep.

This is mostly useful for writing benchmarks where you want to hold the GVL for
a specified amount of time.

## Usage

```ruby
require "nanosleep"

# Sleep for 2 seconds without holding the GVL
Nanosleep.s(2)

# Sleep for 2 seconds while holding the GVL
Nanosleep.s(2, hold_gvl: true)

# Sleep for 100 milliseconds without holding the GVL
Nanosleep.ms(100)

# Sleep for 100 milliseconds while holding the GVL
Nanosleep.ms(100, hold_gvl: true)

# Sleep for 100 nanoseconds without holding the GVL
Nanosleep.ns(100)

# Sleep for 100 nanoseconds while holding the GVL
Nanosleep.ns(100, hold_gvl: true)
```
