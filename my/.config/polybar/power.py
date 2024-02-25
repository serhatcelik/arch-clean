#!/usr/bin/env python3

import sys
import tkinter.messagebox as mb


def ask():
    if not mb.askyesno(sys.argv[1], 'Are you sure?'):
        sys.exit(1)


ask()
