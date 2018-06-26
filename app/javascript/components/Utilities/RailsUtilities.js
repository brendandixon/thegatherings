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
