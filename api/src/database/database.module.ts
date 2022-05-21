import { Global, Logger, Module, OnModuleInit } from '@nestjs/common'
import { Database } from './database'
import * as fs from 'node:fs'
import { PERSISTENCE_PATH } from './database.constants'

@Global()
@Module({
  providers: [Database],
  exports: [Database],
})
export class DatabaseModule implements OnModuleInit {
  public readonly logger: Logger = new Logger(DatabaseModule.name)

  public onModuleInit(): void {
    const didFindPersistenceDirectory = fs.existsSync(PERSISTENCE_PATH)
    this.logger.log(`Persistence directory already exists.`)

    if (!didFindPersistenceDirectory) {
      this.logger.log(`Persistence directory not found. Creating persistence directory.`)
      fs.mkdirSync(PERSISTENCE_PATH)
    }
  }
}
