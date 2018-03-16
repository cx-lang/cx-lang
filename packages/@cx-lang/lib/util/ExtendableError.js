import { format } from "util";

export default class ExtendableError extends Error {

    constructor( ...data ) {

        super();

        this.name = this.constructor.name;
        this.message = data.length === 0 ? void 0
                     : data.length === 1 ? data[ 0 ]
                     : format( ...data );

        Error.captureStackTrace( this, this.constructor );

    }

}
