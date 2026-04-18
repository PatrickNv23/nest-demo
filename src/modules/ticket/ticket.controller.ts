import { Controller, Get, Post, Body, Param, Patch } from '@nestjs/common';
import { TicketService } from './ticket.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketStatusDto } from './dto/update-ticket-status.dto';

@Controller('ticket')
export class TicketController {
  constructor(private readonly ticketService: TicketService) { }

  @Post()
  create(@Body() createTicketDto: CreateTicketDto) {
    return this.ticketService.create(createTicketDto);
  }

  @Get('customer/:customerId')
  findCustomerTickets(@Param('customerId') customerId: string) {
    return this.ticketService.findCustomerTickets(customerId);
  }

  @Get('agent/:agentId')
  findAgentTickets(@Param('agentId') agentId: string) {
    return this.ticketService.findAgentTickets(agentId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.ticketService.findOne(id);
  }

  @Get('department/:departmentId/unassigned')
  findUnassignedByDepartment(@Param('departmentId') departmentId: string) {
    return this.ticketService.findUnassignedByDepartment(departmentId);
  }

  @Patch(':id/status')
  updateStatus(
    @Param('id') ticketId: string,
    @Body() updateTicketStatusDto: UpdateTicketStatusDto
  ) {
    return this.ticketService.updateStatus(ticketId, updateTicketStatusDto);
  }
}
