import { assert, BaseClass } from "./helpers"
import { Context, Interpreter, Program } from "./language"

const EXPECTING_CONTEXT = "Expecting an instance of 'language.Context' as option for Parser"
const EXPECTING_INTERPRETER = "Expecting an instance of 'language.Interpreter' as option for Parser"

export default class Parser extends BaseClass {

  static initialize ( parser, context, interpreter ) {
    var config = Interpreter.defaultConfig();
    if ( typeof interpreter == 'object' && !(interpreter instanceof Interpreter) ) {
      config = Interpreter.copyConfig(interpreter)
      interpreter = null
    }

    if ( context ) assert(context instanceof Context, EXPECTING_CONTEXT)
    if ( interpreter ) assert(interpreter instanceof Interpreter, EXPECTING_INTERPRETER)

    parser.context = context || new Context()
    parser.interpreter = interpreter || new Interpreter(config)

    context.parser = parser
    context.interpreter = interpreter

    interpreter.parser = parser
    interpreter.context = context
  }

  static setOptions ( parser, options ) {

    parser.option('parseMode', options.parseMode || 'strict')
    parser.option('allowAnyType', options.allowAnyType || false)
    parser.option('allowVoidType', options.allowVoidType || true)

  }

  constructor ( options = {} ) {

    super()
    
    initialize(this, options.context, options.interpreter)

    setOptions(this, options)

  }

  option ( setting, value ) {
    return this.context.option(setting, value)
  }

  get state() {
    return this.context.currentState() || this.context.lastState()
  }

  get active() {
    return this.state.isOpen()
  }

  get inactive() {
    return this.state.isClosed()
  }

  get done() {
    return this.interpreter.isComplete()
  }

  parse ( source ) {
    var ctx = this.context, result
    ctx.createState(new Source(source, this))
    result = Program.parse(ctx).evaluate()
    ctx.clearState()
    return result
  }

}

export function parse ( source, options ) {
  return (new Parser(options)).parse(source)
}

export * from "./language/common/errors"
