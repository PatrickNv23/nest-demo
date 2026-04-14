import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CatController } from './modules/cat/cat.controller';
import { CatService } from './modules/cat/cat.service';
import { UserModule } from './modules/user/user.module';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './modules/prisma/prisma.module';
import { RoleModule } from './modules/role/role.module';
import { DepartmentModule } from './modules/department/department.module';

@Module({
  imports: [ConfigModule.forRoot(), UserModule, PrismaModule, RoleModule, DepartmentModule],
  controllers: [AppController, CatController],
  providers: [AppService, CatService],
})
export class AppModule { }
