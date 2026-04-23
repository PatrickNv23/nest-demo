import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './modules/user/user.module';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './modules/prisma/prisma.module';
import { RoleModule } from './modules/role/role.module';
import { DepartmentModule } from './modules/department/department.module';
import { TicketModule } from './modules/ticket/ticket.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [ConfigModule.forRoot(), UserModule, PrismaModule, RoleModule, DepartmentModule, TicketModule, AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
