# Essential scripts for a nice working machine.

# Colourful IP command
export def ip [
    ...args # Arguments to pass to the IP command
] {
    nu -c $"ip -c ($args)"
}
