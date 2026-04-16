import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketDto } from './dto/update-ticket.dto';
import { PrismaService } from '../prisma/prisma.service';
import { TicketStatus } from 'src/common/types/ticket-status.enum';
import { UpdateTicketStatusDto } from './dto/update-ticket-status.dto';

@Injectable()
export class TicketService {

  constructor(private readonly prisma: PrismaService) { }

  async create(createTicketDto: CreateTicketDto) {
    const status = await this.prisma.ticket_statuses.findFirst({
      where: { name: TicketStatus.OPEN, is_active: true }
    });

    if (!status) {
      throw new BadRequestException('Invalid ticket status is not configured');
    }

    return this.prisma.tickets.create({
      data: {
        title: createTicketDto.title,
        description: createTicketDto.description,
        priority: createTicketDto.priority,
        type_id: createTicketDto.typeId,
        department_id: createTicketDto.departmentId,
        creator_user_id: createTicketDto.creatordId,
        status_id: status.id,
        created_by: createTicketDto.creatordId,
        updated_by: createTicketDto.creatordId,
        is_active: true
      }
    })
  }

  async findCustomerTickets(customerId: string) {
    await this.prisma.tickets.findMany({
      where: { creator_user_id: customerId, is_active: true },
      include: { ticket_statuses: true, ticket_types: true }
    })
  }

  async findAgentTickets(agentId: string) {
    await this.prisma.tickets.findMany({
      where: { assigned_agent_id: agentId, is_active: true },
      include: { ticket_statuses: true, ticket_types: true }
    })
  }

  async findOne(id: string) {
    const ticket = await this.prisma.tickets.findUnique({
      where: { id, is_active: true }
    });

    if (!ticket || !ticket.is_active) {
      throw new NotFoundException(`Ticket with id ${id} not found`);
    }

    return ticket;
  }

  async findUnassignedByDepartment(departmentId: string) {
    return await this.prisma.tickets.findMany({
      where: {
        department_id: departmentId,
        assigned_agent_id: null,
        is_active: true
      },
      include: { ticket_statuses: true, ticket_types: true }
    });
  }

  async updateStatus(ticketId: string, updaterId: string, updateTicketStatusDto: UpdateTicketStatusDto) {

    const ticket = await this.prisma.tickets.findUnique({
      where: { id: ticketId, is_active: true },
      include: { ticket_statuses: true }
    });

    if (!ticket) {
      throw new NotFoundException(`Ticket with id ${ticketId} not found`);
    }

    const nextStatus = await this.prisma.ticket_statuses.findUnique({
      where: { id: updateTicketStatusDto.statusId, is_active: true }
    });

    if (!nextStatus) {
      throw new BadRequestException(`Invalid ticket status`);
    }

    const currentOrder = ticket.ticket_statuses.step_order;
    const nextOrder = nextStatus.step_order;

    if (nextOrder !== currentOrder + 1) {
      throw new BadRequestException(`Invalid ticket status transition`);
    }

    // update

  }
}

