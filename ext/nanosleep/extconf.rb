# frozen_string_literal: true
require "mkmf"

abort unless have_func("nanosleep")
abort unless find_header("time.h")

create_makefile "nanosleep"
