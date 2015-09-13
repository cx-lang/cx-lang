WhiteSpace "whitespace"
  = "\t"
  / "\v"
  / "\f"
  / " "
  / "\uFEFF"
  / UnicodeZs

// Unicode 6+ Separator Space
UnicodeZs
= [\u0020\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000]

LineTerminator
  = [\n\r\u2028\u2029]

LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028"
  / "\u2029"
