# frozen_string_literal: true

require "rack/test"
require "test/unit"

this_dir = File.join(File.dirname(__FILE__), "..", "lib")
$LOAD_PATH.unshift File.expand_path(this_dir)

require "rr-amy"
