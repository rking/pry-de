# pry-de

Run-time Ruby Development Environment based on Pry. [Maturity: Infantile]

See: https://github.com/pry/pry/wiki/pry-de

## F-keys

Add this to your `~/.inputrc` to get F-keys similar to Firebug, etc.:

    $if Ruby
        $if mode=vi
            set keymap vi-command
            "[19~":   "continue\n"  # <F8>
            "[32~":   "try-again\n" # <Shift-F8> (urxvt)
            "[19;2~": "try-again\n" # <Shift-F8> (xterm, gnome-terminal)
            "[21~":   "next\n"      # <F10>
            "[23~":   "step\n"      # <F11>
            "[23$":   "finish\n"    # Shift+<F11> (urxvt)
            "[23;2~": "finish\n"    # Shift+<F11> (xterm, gnome-terminal)
        $else
            "\e[19~":   "continue\n"
            "\e[32~":   "try-again\n"
            "\e[19;2~": "try-again\n"
            "\e[21~":   "next\n"
            "\e[23~":   "step\n"
            "\e[23$":   "finish\n"
            "\e[23;2~": "finish\n"
        $endif
    $endif

## Commands that come with pry-de

 - `,,` (toggle ,-prefixes off/on commands, for terse input)
 - `,-` (Remove last item from history, in preparation for a `play` command)
 - `,b` (Alias for `break`)
 - `,c` (Alias for `continue`)
 - `,f` (Alias for `finish`)
 - `,hs` (hist --save ~/.pry_history - e.g. for vim <leader>ph)
 - `,lft` (load _file_ and try-again, for pry-rescue/minitest)
 - `,lib` (edit lib/)
 - `,loc` (Show hash of local vars)
 - `,m` (play method body only)
 - `,n` (Alias for `next`)
 - `,refactor` (No description.)
 - `,s` (Alias for `step`)
 - `,w` (Alias for `whereami`)
 - `/[$?]?\s*(.*?)\s*,,e\s*(.*)/` (edit from anywhere on the line)
 - `?$` (show-doc + show-source)
 - `C$` (Hop to tag in the Ruby C source)
 - `cat--EX` (show whole backtrace)

