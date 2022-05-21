import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'

const applicationPort = process.env.APPLICATION_PORT ?? 3000

void (async () => {
  const app = await NestFactory.create(AppModule)

  await app.listen(applicationPort)
})()
  .then(() => {
    console.log(`Application is listening on port ${applicationPort} 🚀`)
  })
  .catch((error) => {
    console.error('An error has occurred while trying to start the server 💥')
    console.error(error)
  })
