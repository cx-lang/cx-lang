__
  = (WhiteSpace / LineTerminatorSequence / Comment)*

_
  = (WhiteSpace / MultiLineCommentNoLineTerminator)*

EOS
  = __ ";"
  / _ SingleLineComment? LineTerminatorSequence
  / _ &"}"
  / __ EOF

EOF
  = !.
