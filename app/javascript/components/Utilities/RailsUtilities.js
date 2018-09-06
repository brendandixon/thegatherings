import moment from 'moment'
import jQuery from 'jquery'

export const retrieveCSPNonce  = () => {
    return jQuery('head > meta[name=csp-nonce]').attr('content')
}

export const errorsToMessages = (errors, defaultErrors = {}) => {
    let fullMessages = []
    errors = errors || defaultErrors
    for (let field in errors) {
        let messages = (errors[field] || '').toString().trim()
        if (messages.length <= 0) {
            continue
        }

        let fieldName = ''
        if (field != 'base') {
            fieldName = field.split('_')
            fieldName = fieldName.map(fn => fn.substring(0, 1).toUpperCase() + fn.substring(1)).join(' ') + ' '
        }
        
        if (typeof messages == 'string') {
            messages = [messages]
        }
        for (let message of messages) {
            fullMessages.push(`${fieldName}${message}`)
        }
    }

    return fullMessages
}

const reRailsName = /^(\w+)\[(\w+)\]$/
export const formToJSON = (form) => {
    let data = {}
    for (let entry of new FormData(form)) {
        let match = reRailsName.exec(entry[0])
        if (match) {
            data[match[1]] = data[match[1]] || {}
            data[match[1]][match[2]] = entry[1]
        } else {
            data[entry[0]] = entry[1]
        }
    }
    return JSON.stringify(data)
}

export const makeRailsId= (model, member) => `${model}_${member}`
export const makeRailsName = (model, member) => `${model}[${member}]`

export const parseRailsDate = (d) => {
    let m = moment(d, moment.ISO_8601)
    return m.isValid() ? m : null
}

export const formatRailsDate = (d, f = 'llll') => {
    let m = parseRailsDate(d)
    return m ? m.format(f) : null
}

export const fromNowRailsDate = (d) => {
    let m = parseRailsDate(d)
    return m ? m.fromNow() : null
}
