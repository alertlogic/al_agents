#!/usr/bin/env bats

@test "al-agent status reporting]" {
  run /etc/init.d/al-agent status
  [ "$status" -eq 0 ]
}
