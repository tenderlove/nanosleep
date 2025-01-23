require "nanosleep"
require "minitest/autorun"

class NanosleepTest < Minitest::Test
  class Channel
    def self.new
      Ractor.new do
        loop do
          Ractor.yield Ractor.receive
        end
      end
    end
  end

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def test_hold_gvl
    latch = Queue.new
    t = Thread.new {
      latch.pop
      Nanosleep.s 1, hold_gvl: true
    }
    start = now
    latch << true
    Nanosleep.s 1, hold_gvl: true
    t.join
    elapsed = now - start
    # should be about 2 seconds
    assert_in_delta 2.0, elapsed, 0.2
  end

  def test_no_gvl
    latch = Queue.new
    t = Thread.new {
      latch.pop
      Nanosleep.s 1
    }
    start = now
    latch << true
    Nanosleep.s 1
    t.join
    elapsed = now - start
    # should be about 1 seconds
    assert_in_delta 1.0, elapsed, 0.2
  end

  def test_ractor_with_gvl
    # even though we hold the GVL, the GVL is actually per Ractor, so
    # we will see only 1 second elapse
    channel = Channel.new
    r = Ractor.new {
      Ractor.receive # block until ready
      Nanosleep.s 1, hold_gvl: true
    }
    start = now
    r.send(true)
    Nanosleep.s 1, hold_gvl: true
    r.take
    elapsed = now - start
    # should be about 1 seconds
    assert_in_delta 1.0, elapsed, 0.2
  end
end
