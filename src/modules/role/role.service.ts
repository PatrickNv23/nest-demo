import { Injectable, NotFoundException } from '@nestjs/common';
import { Prisma } from 'src/generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RoleService {

  constructor(private readonly prisma: PrismaService) { }

  async findAll() {
    return await this.prisma.roles.findMany({
      where: {
        is_active: true
      }
    });
  }

  async findOne(id: string) {
    const role = await this.prisma.roles.findUnique({
      where: { id, is_active: true }
    });

    if (!role || !role.is_active) {
      throw new NotFoundException(`User with id ${id} not found`);
    }

    return role;
  }
}
