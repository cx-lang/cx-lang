Literal
  = NullLiteral
  / BooleanLiteral
  / NumericLiteral
  / CharLiteral
  / StringLiteral
  / RegExpLiteral

NullLiteral
  = NullToken { return append({ type: "literal", kind: "Null" }); }

BooleanLiteral
  = TrueToken  { return append({ type: "literal", kind: "Boolean", value: true }); }
  / FalseToken { return append({ type: "literal", kind: "Boolean", value: false }); }

@import "numbers.pegjs"

@import "char.pegjs"

@import "strings.pegjs"

@import "regexps.pegjs"
