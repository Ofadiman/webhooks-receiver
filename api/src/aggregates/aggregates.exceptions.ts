import { NotFoundException } from '@nestjs/common'

export class AggregateNotFoundException extends NotFoundException {
  public constructor(args: { aggregateId: string }) {
    super(`Aggregate ${args.aggregateId} not found.`)
  }
}

export class EntryNotFoundException extends NotFoundException {
  public constructor(args: { aggregateId: string; entryId: string }) {
    super(`Entry ${args.entryId} found found in aggregate ${args.aggregateId}.`)
  }
}
