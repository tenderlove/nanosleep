require "nanosleep.so"

module Nanosleep
  NS_IN_S = 1000000000
  private_constant :NS_IN_S

  NS_IN_MS = 1000000
  private_constant :NS_IN_MS

  def ns amt, hold_gvl: false
    seconds = amt / NS_IN_S
    nsec = amt % NS_IN_S
    nsleep(seconds, nsec, hold_gvl)
  end
  module_function :ns

  def ms amt, hold_gvl: false
    ns(amt * NS_IN_MS, hold_gvl:)
  end
  module_function :ms

  def s amt, hold_gvl: false
    ns(amt * NS_IN_S, hold_gvl:)
  end
  module_function :s

  module_function :nsleep
end
