import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { NestExpressApplication } from '@nestjs/platform-express'
import * as path from 'path'

const applicationPort = process.env.APPLICATION_PORT ?? 3000

void (async () => {
  const app = await NestFactory.create<NestExpressApplication>(AppModule)

  app.useStaticAssets(path.join(__dirname, './.well-known'), {
    dotfiles: 'allow',
  })

  await app.listen(applicationPort)
})()
  .then(() => {
    console.log(`Application is listening on port ${applicationPort} 🚀`)
  })
  .catch((error) => {
    console.error('An error has occurred while trying to start the server 💥')
    console.error(error)
  })
