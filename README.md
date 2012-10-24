# pry-de

Run-time Ruby Development Environment based on Pry. [Maturity: Infantile]

See: https://github.com/pry/pry/wiki/pry-de

 - `,,` (toggle ,-prefixes off/on commands, for terse input)
 - `,-` (Remove last item from history, in preparation for a `play` command)
 - `,b` (Alias for `break`)
 - `,c` (Alias for `continue`)
 - `,f` (Alias for `finish`)
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
