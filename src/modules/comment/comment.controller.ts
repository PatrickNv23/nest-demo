import { Controller, Post, Body, Param, UploadedFiles, UseInterceptors, Get, ParseUUIDPipe } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { multerOptions } from './multer.config';

@Controller('comment')
export class CommentController {
  constructor(private readonly commentService: CommentService) { }

  @Post('tickets/:ticketId')
  @UseInterceptors(FilesInterceptor('files', 10, multerOptions))
  async create(
    @Param('ticketId') ticketId: string,
    @Body() body: { userId: string; content: string; isInternal: boolean },
    @UploadedFiles() files: Express.Multer.File[]
  ) {

    const createCommentDto: CreateCommentDto = {
      ticketId,
      userId: body.userId,
      content: body.content,
      isInternal: body.isInternal,
    };

    return await this.commentService.create(createCommentDto, files);
  }

  @Get(':commentId/attachments')
  async listAttachments(@Param('commentId', ParseUUIDPipe) commentId: string) {
    return await this.commentService.getAttachments(commentId);
  }
}
