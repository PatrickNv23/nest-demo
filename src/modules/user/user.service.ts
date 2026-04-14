import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import { Role } from 'src/common/types/role.enum';

@Injectable()
export class UserService {

  constructor(private readonly prisma: PrismaService) { }

  async create(createUserDto: CreateUserDto) {
    // verify if user exists
    const existing = await this.prisma.users.findFirst({
      where: {
        OR: [{ email: createUserDto.email }, { username: createUserDto.userName, is_active: true }]
      }
    })

    if (existing) {
      throw new BadRequestException('User with the same email or username already exists');
    }

    const passwordHash = await bcrypt.hash(createUserDto.password, 10);

    return this.prisma.users.create({
      data: {
        username: createUserDto.userName,
        email: createUserDto.email,
        phone_number: createUserDto.phoneNumber,
        password_hash: passwordHash,
        role_id: createUserDto.roleId,
        department_id: createUserDto.departmentId,
        is_active: true
      },
      select: {
        id: true,
        username: true,
        email: true,
        // roles: true,
        // departments: true
      }
    });
  }

  async findAll() {
    return await this.prisma.users.findMany({
      where: { is_active: true },
      include: { roles: true, departments: true }
    });
  }

  async findOne(id: string) {
    const user = await this.prisma.users.findUnique({
      where: { id, is_active: true },
      include: { roles: true, departments: true }
    });

    if (!user || !user.is_active) {
      throw new NotFoundException(`User with id ${id} not found`);
    }

    return user;
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const user = await this.findOne(id);

    const updatePayload: Record<string, unknown> = {
      username: updateUserDto.userName ?? user.username,
      email: updateUserDto.email ?? user.email,
      phone_number: updateUserDto.phoneNumber ?? user.phone_number,
      updated_at: new Date()
    }

    if (updateUserDto.password) {
      updatePayload.password_hash = await bcrypt.hash(updateUserDto.password, 10);
    }

    if (updateUserDto.roleId !== undefined) {
      updatePayload.role_id = updateUserDto.roleId;
    }

    if (updateUserDto.departmentId !== undefined) {
      updatePayload.department_id = updateUserDto.departmentId;
    }

    return this.prisma.users.update({
      where: { id, is_active: true },
      data: updatePayload,
      include: { roles: true, departments: true }
    })
  }

  async remove(id: string) {
    return await this.prisma.users.update({
      where: { is_active: true, id },
      data: { is_active: false }
    });
  }

  async findAgentsByDepartment(departmentId: string) {
    return await this.prisma.users.findMany({
      where: {
        department_id: departmentId,
        is_active: true,
        roles: {
          name: Role.AGENT,
          is_active: true
        }
      }
    })
  }
}
