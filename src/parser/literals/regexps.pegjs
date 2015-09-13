RegExpLiteral "Regular Expression"
  = "/" chars:RegExpCharacter* "/" flags:Flags? {
      return append({ type: "literal", kind: "RegularExpression", value: JSON.stringify(chars.join("")), flags: flags });
    }

RegExpCharacter
  = '\\' "/" { return "/"; }
  / !"/" SourceCharacter { return text(); }

Flags
  = chars: AlphaCharacter+ {
      return chars.join("");
    }
