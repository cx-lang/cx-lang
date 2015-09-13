StringLiteral "string"
  = CharLiteral
  / modifier:AlphaCharacter? string:(DoubleString / SingleString / TemplateString) {
      if ( modifier ) string.modifier = modifier;
      return append(string);
    }

DoubleString
  = '"' chars:DoubleStringCharacter* '"' {
      return { type: "literal", kind: "DoubleString", value: JSON.stringify(chars.join("")) };
    }

SingleString
  = "'" chars:SingleStringCharacter* "'" {
      return { type: "literal", kind: "SingleString", value: JSON.stringify(chars.join("")) };
    }

TemplateString
  = "`" chars:TemplateStringCharacter* "`" {
      return { type: "literal", kind: "TemplateString", value: JSON.stringify(chars.join("")) };
    }

DoubleStringCharacter
  = '\\' '"' { return '"'; }
  / !'"' SourceCharacter { return text(); }

SingleStringCharacter
  = '\\' "'" { return "'"; }
  / !"'" SourceCharacter { return text(); }

TemplateStringCharacter
  = '\\' "`" { return "`"; }
  / !"`" SourceCharacter { return text(); }
