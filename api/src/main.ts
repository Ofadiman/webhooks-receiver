import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { NestExpressApplication } from '@nestjs/platform-express'
import * as path from 'path'
import * as fs from 'fs'

const applicationPort = process.env.APPLICATION_PORT ?? 3000

void (async () => {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    httpsOptions:
      process.env.NODE_ENV === 'production'
        ? {
            key: fs.readFileSync('letsencrypt/live/webhooks-receiver.ofadiman.com/privkey.pem', {
              encoding: 'utf8',
            }),
            cert: fs.readFileSync('letsencrypt/live/webhooks-receiver.ofadiman.com/fullchain.pem', {
              encoding: 'utf8',
            }),
          }
        : {},
  })

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
