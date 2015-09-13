CharLiteral "char"
  = "'" ch:[\u0000-\uFFFF] "'" {
      return append({ type: "literal", kind: "Char", value: ch, code: toCharCode(ch) });
    }
