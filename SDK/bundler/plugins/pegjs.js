'use strict'

const { generate } = require( 'pegjs-dev' )
const { createFilter } = require( 'rollup-pluginutils' )

module.exports = function createPlugin( options = {} ) {

  const target = options.target || 'es6'
  const include = options.include || [ '*.pegjs', '**/*.pegjs' ]
  const exclude = options.exclude
  options.output = 'source'

  delete options.target
  delete options.include
  delete options.exclude

  const filter = createFilter( include, exclude )
  const exporter = target === 'es6' ? 'export default' : 'module.exports ='

  return {

    name: 'pegjs',

    transform( grammar, id ) {

      if ( ! filter( id ) ) return null

      options.filename = id

      const parser = generate( grammar, options )

      return {

        code: exporter + ' ' + parser,
        map: { mappings: '' }

      }

    }

  }

}
