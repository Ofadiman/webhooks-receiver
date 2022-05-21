import { IsNotEmpty, IsString, IsUUID } from 'class-validator'

export class CreateAggregateRequestBodyDto {
  @IsString()
  @IsNotEmpty()
  public readonly name: string
}

export class ReadAggregateByIdRequestParametersDto {
  @IsUUID()
  public readonly aggregateId: string
}

export class CreateEntryRequestParametersDto {
  @IsUUID()
  public readonly aggregateId: string
}
export class ReadEntryByIdRequestParametersDto {
  @IsUUID()
  public readonly aggregateId: string

  @IsUUID()
  public entryId: string
}
