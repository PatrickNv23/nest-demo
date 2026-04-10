import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CatController } from './modules/cat/cat.controller';
import { CatService } from './modules/cat/cat.service';
import { UserModule } from './modules/user/user.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [ConfigModule.forRoot(), UserModule],
  controllers: [AppController, CatController],
  providers: [AppService, CatService],
})
export class AppModule {}
