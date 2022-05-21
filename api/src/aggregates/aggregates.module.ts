import { AggregatesController } from './aggregates.controller'
import { Module } from '@nestjs/common'

@Module({
  controllers: [AggregatesController],
})
export class AggregatesModule {}
