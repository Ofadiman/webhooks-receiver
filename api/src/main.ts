import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'

void (async () => {
  const app = await NestFactory.create(AppModule)

  await app.listen(process.env.APPLICATION_PORT)
})()
  .then(() => {
    console.log(`Application is listening on port ${process.env.APPLICATION_PORT} 🚀`)
  })
  .catch((error) => {
    console.error('An error has occurred while trying to start the server 💥')
    console.error(error)
  })
