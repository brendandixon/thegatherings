export const toInteger = (id) => {
    id = id ? parseInt(id) : NaN
    if (id == NaN) {
        id = -1
    }
    if (id < 0) {
        id = null
    }
    return id
}
