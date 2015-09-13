Identifier
  = $(IdentifierStart IdentifierPart*)

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
