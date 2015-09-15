Variable
  = !Keyword name:Identifier {
      return append({ type: 'variable', value: identifier });
    }

Identifier "identifier"
  = $(IdentifierStart IdentifierPart*)

Pathname
  = first:Variable rest:(__ "." __ Identifier)+ {
      return buildList(first, rest, 3);
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
