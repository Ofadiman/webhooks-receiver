import { Module, ValidationPipe } from '@nestjs/common'
import { APP_PIPE } from '@nestjs/core'
import { HealthModule } from './health/health.module'
import { AggregatesModule } from './aggregates/aggregates.module'
import { DatabaseModule } from './database/database.module'

@Module({
  imports: [HealthModule, AggregatesModule, DatabaseModule],
  providers: [
    {
      provide: APP_PIPE,
      useClass: ValidationPipe,
    },
  ],
})
export class AppModule {}
