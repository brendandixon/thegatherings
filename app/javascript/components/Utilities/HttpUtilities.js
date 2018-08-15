export class HttpError extends Error {
    constructor(response) {
        super(`${response.status} for ${response.url}`);
        this.name = 'HttpError';
        this.response = response;
    }
}

export class HttpRailsError extends HttpError {
    constructor(response, errors) {
        super(response)
        this.name = 'HttpRailsError'
        this.errors = errors
    }
}

export const addGroupsQuery = (path, props) => {
    if (!path) {
        return null
    }

    let queryString = []
    
    if (props.community) {
        queryString.push(`community_id=${props.community.id}`)
    }

    if (props.campus) {
        queryString.push(`campus_id=${props.campus.id}`)
    }

    if (props.gathering) {
        queryString.push(`gathering_id=${props.gathering.id}`)
    }

    return (
        queryString.length <= 0
            ? path
            : path + '?' + queryString.join('&')
    )
}

export const readJSONResponse = (response) => {
    return response
        .json()
        .then(json => {
            return Promise.resolve({response: response, json: json})
        })
        .catch(error => {
            return Promise.reject({response: response, json: {errors: {base: 'Invalid JSON received'}}})
        })
}

export const evaluateJSONResponse = (result) => {
    if (result.response.ok) {
        return Promise.resolve(result.json)
    }
    return Promise.reject(new HttpRailsError(result.response, result.json['errors'] || {}))
}

export const evaluateResponse = (response) => {
    if (response.ok) {
        return Promise.resolve(response)
    }
    return Promise.reject(new HttpError(response))
}
