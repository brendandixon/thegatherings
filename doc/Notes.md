# Notes

- Models cannot be ActiveRecord-based. They may use ActiveRecord, but the consumers should be unaware. This will
ease transition, if needed, to a non-SQL store.