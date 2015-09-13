NumericLiteral "number"
  = number:(HexIntegerLiteral / DecimalLiteral) {
      return append(number);
    }

Integer
  = $DecimalDigit+

Float
  = $(Integer "." Integer)
  / f:$(Integer "." Integer) "f" { return f; }
  / f:Integer "f" { return f; }

MultiFloat
  = $(
        Float "." MultiFloat
      / Float "." Float
      / Float "." Integer
    )

Exponent
  = "e"i sign:[+-]? value:Integer {
      var ast = { value: value };
      if ( sign ) ast.sign = sign;
      return ast;
    }

HexIntegerLiteral
  = "0x"i digits:$HexDigit+ {
      return { type: "literal", kind: "HexInteger", value: "0x" + digits };
     }

DecimalLiteral
  = sign:[+-] value:MultiFloat exponent:Exponent? {
      return { type: "literal", kind: 'SignedMultiFloat', sign: sign, value: value, exponent: exponent };
    }
  / value:MultiFloat exponent:Exponent?  {
      return { type: "literal", kind: 'UnsignedMultiFloat', value: value, exponent: exponent };
    }
  / sign:[+-] value:Float exponent:Exponent? {
      return { type: "literal", kind: 'SignedFloat', sign: sign, value: value, exponent: exponent };
    }
  / value:Float exponent:Exponent?  {
      return { type: "literal", kind: 'UnsignedFloat', value: value, exponent: exponent };
    }
  / sign:[+-] value:Integer exponent:Exponent? {
      return { type: "literal", kind: 'SignedInteger', sign: sign, value: value, exponent: exponent };
    }
  / value:Integer exponent:Exponent?  {
      return { type: "literal", kind: 'UnsignedInteger', value: value, exponent: exponent };
    }
