export default class StatusTracker {
    constructor(keys) {
        this.status = {}
        for (let key of keys) {
            this.status[key] = true
        }
    }

    markReady(key, isReady = true) {
        this.status[key] = isReady
    }

    markBusy(key) {
        this.status[key] = false
    }

    setBusy() {
        for (let key in this.status) {
            this.status[key] = false
        }
    }

    setReady() {
        for (let key in this.status) {
            this.status[key] = true
        }
    }

    isBusy(key) {
        return this.status[key] == false
    }

    isReady(key) {
        return this.status[key] == true
    }

    allReady() {
        let f = true
        for (let key in this.status) {
            f = f && (this.status[key] == true)
        }
        return f
    }
}
