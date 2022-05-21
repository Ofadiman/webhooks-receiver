export type Entry = {
  payload: unknown
  metadata: {
    createDate: string
    id: string
  }
}

export type Aggregate = {
  id: string
  name: string
  createDate: string
  entries: Entry[]
}
