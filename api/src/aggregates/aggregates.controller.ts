import { Body, Controller, Get, Logger, Param, Post } from '@nestjs/common'
import * as uuid from 'uuid'
import { Aggregate, Entry } from './aggregates.types'
import { Database } from '../database/database'
import {
  CreateAggregateRequestBodyDto,
  CreateEntryRequestParametersDto,
  ReadAggregateByIdRequestParametersDto,
  ReadEntryByIdRequestParametersDto,
} from './aggregates.dto'
import { AggregateNotFoundException, EntryNotFoundException } from './aggregates.exceptions'

@Controller('aggregates')
export class AggregatesController {
  public logger = new Logger(AggregatesController.name)

  public constructor(private readonly database: Database) {}

  @Post()
  public createAggregate(@Body() body: CreateAggregateRequestBodyDto): Aggregate {
    this.logger.log(`Creating aggregate.`, { body })

    const aggregate = this.database.save({
      createDate: new Date().toISOString(),
      id: uuid.v4(),
      name: body.name,
      entries: [],
    })

    return aggregate
  }

  @Get(':aggregateId')
  public readAggregateById(@Param() parameters: ReadAggregateByIdRequestParametersDto): Aggregate {
    this.logger.log(`Reading aggregate.`, { parameters })

    const aggregate = this.database.findById(parameters.aggregateId)

    if (aggregate === undefined) {
      throw new AggregateNotFoundException({ aggregateId: parameters.aggregateId })
    }

    return aggregate
  }

  @Post(':aggregateId/entries')
  public createEntry(
    @Param() parameters: CreateEntryRequestParametersDto,
    @Body() body: object | Array<unknown>,
  ): Entry {
    this.logger.log(`Creating entry.`, { parameters, body })
    const aggregate = this.database.findById(parameters.aggregateId)

    if (aggregate === undefined) {
      throw new AggregateNotFoundException({ aggregateId: parameters.aggregateId })
    }

    const entry: Entry = {
      metadata: {
        createDate: new Date().toISOString(),
        id: uuid.v4(),
      },
      payload: body,
    }

    aggregate.entries.push(entry)

    this.database.save(aggregate)

    return entry
  }

  @Get(':aggregateId/entries/:entryId')
  public readEntryById(@Param() parameters: ReadEntryByIdRequestParametersDto): Entry {
    this.logger.log(`Reading entry.`, { parameters })

    const aggregate = this.database.findById(parameters.aggregateId)
    if (aggregate === undefined) {
      throw new AggregateNotFoundException({ aggregateId: parameters.aggregateId })
    }

    const foundEntry = aggregate.entries.find((entry) => entry.metadata.id === parameters.entryId)
    if (foundEntry === undefined) {
      throw new EntryNotFoundException({
        entryId: parameters.entryId,
        aggregateId: parameters.aggregateId,
      })
    }

    return foundEntry
  }
}
