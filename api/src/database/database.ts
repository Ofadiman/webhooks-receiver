import { Injectable } from '@nestjs/common'
import { Aggregate } from '../aggregates/aggregates.types'
import * as fs from 'node:fs'
import { PERSISTENCE_PATH } from './database.constants'

@Injectable()
export class Database {
  public save(aggregate: Aggregate): Aggregate {
    const aggregateFilePath = `${PERSISTENCE_PATH}/${aggregate.id}.json`

    fs.writeFileSync(aggregateFilePath, JSON.stringify(aggregate), { encoding: 'utf8' })

    return aggregate
  }

  public findById(aggregateId: string): Aggregate | undefined {
    const aggregateFilePath = `${PERSISTENCE_PATH}/${aggregateId}.json`

    const isAggregateFileCreated = fs.existsSync(aggregateFilePath)
    if (!isAggregateFileCreated) {
      return
    }

    const aggregate: Aggregate = JSON.parse(
      fs.readFileSync(aggregateFilePath, { encoding: 'utf8' }),
    )

    return aggregate
  }
}
