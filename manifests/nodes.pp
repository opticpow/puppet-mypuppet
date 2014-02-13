node default {
  notify { "!!! NO HOST ENTRY FOUND. PLEASE UPDATE NODES.PP WITH THIS NODE TYPE !!!": }
}

node unix_default {
    include screen
    include pbis
}

node styx inherits unix_default {
    # noop
}

