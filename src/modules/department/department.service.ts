import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateDepartmentDto } from './dto/create-department.dto';
import { UpdateDepartmentDto } from './dto/update-department.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DepartmentService {

  constructor(private readonly prisma: PrismaService) { }

  async create(createDepartmentDto: CreateDepartmentDto) {
    return this.prisma.departments.create({
      data: {
        name: createDepartmentDto.name,
        description: createDepartmentDto.description,
        is_active: true
      },
      select: {
        id: true,
        name: true,
        description: true
      }
    });
  }

  async findAll() {
    return await this.prisma.departments.findMany({
      where: { is_active: true }
    });
  }

  async findOne(id: string) {

    const department = await this.prisma.departments.findUnique({
      where: { id, is_active: true }
    });

    if (!department || !department.is_active) {
      throw new NotFoundException(`User with id ${id} not found`);
    }

    return department;
  }

  async update(id: string, updateDepartmentDto: UpdateDepartmentDto) {
    const department = await this.findOne(id);

    const updatePayload: Record<string, unknown> = {
      name: updateDepartmentDto.name ?? department.name,
      description: updateDepartmentDto.description ?? department.description,
      updated_at: new Date()
    }

    return this.prisma.departments.update({
      where: { id, is_active: true },
      data: updatePayload
    })
  }

  async remove(id: string) {
    return await this.prisma.departments.update({
      where: { is_active: true, id },
      data: { is_active: false }
    });
  }
}
