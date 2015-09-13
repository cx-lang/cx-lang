Identifier
  = !Keyword name:IdentifierName { return name; }

IdentifierName "identifier"
  = identifier:$(IdentifierStart IdentifierPart*) {
      return append({ type: 'identifier', value: identifier });
    }

IdentifierStart
  = AlphaCharacter
  / "$"
  / "_"
  / "\\" sequence:UnicodeEscapeSequence { return sequence; }

IdentifierPart
  = IdentifierStart
  / DecimalDigit
  / "\u200C"
  / "\u200D"

UnicodeEscapeSequence
  = "u" digits:$(HexDigit HexDigit HexDigit HexDigit) {
      return String.fromCharCode(parseInt(digits, 16));
    }
