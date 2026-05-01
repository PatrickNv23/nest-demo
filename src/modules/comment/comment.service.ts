import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { PrismaService } from '../prisma/prisma.service';
import { create } from 'domain';

@Injectable()
export class CommentService {

  constructor(private readonly prisma: PrismaService) { }

  async create(createCommentDto: CreateCommentDto, files?: Express.Multer.File[]) {

    // verify ticket
    const ticket = await this.prisma.tickets.findUnique({
      where: { id: createCommentDto.ticketId, is_active: true },
    });

    if (!ticket) {
      throw new NotFoundException('Ticket not found');
    }

    // verify user
    const user = await this.prisma.users.findUnique({
      where: { id: createCommentDto.userId, is_active: true },
    });

    if (!user) {
      throw new BadRequestException('User not found');
    }

    // create transaction
    const comment = await this.prisma.$transaction(async (tx) => {
      const newComment = await tx.comments.create({
        data: {
          ticket_id: createCommentDto.ticketId,
          user_id: createCommentDto.userId,
          content: createCommentDto.content,
          is_internal: createCommentDto.isInternal ?? false,
          is_active: true,
          created_by: createCommentDto.userId,
          updated_by: createCommentDto.userId,
        }
      });

      if (files && files.length > 0) {
        const attachments = files.map((file) => ({
          comment_id: newComment.id,
          file_name: file.originalname,
          file_url: `/uploads/comments/${file.filename}`,
          file_type: file.mimetype,
          is_active: true,
          created_by: createCommentDto.userId,
          updated_by: createCommentDto.userId,
        }));

        await tx.comment_attachments.createMany({ data: attachments });
      }

      return tx.comments.findUnique({
        where: { id: newComment.id, is_active: true },
        include: {
          comment_attachments: {
            where: {
              is_active: true
            }
          }
        }
      })
    })

    return comment;
  }

  async getAttachments(commentId: string) {
    const comment = await this.prisma.comments.findUnique({
      where: { id: commentId, is_active: true },
    });

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    return this.prisma.comment_attachments.findMany({
      where: {
        comment_id: commentId,
        is_active: true
      }
    });
  }

}
