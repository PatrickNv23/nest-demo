import { Controller, Post, Body, Param, UploadedFiles, UseInterceptors, Get, ParseUUIDPipe, Res, HttpException, HttpStatus, StreamableFile } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { multerOptions } from './multer.config';
import * as fs from 'fs';
import type { Response } from 'express';
import archiver from 'archiver';

@Controller('comment')
export class CommentController {
  constructor(private readonly commentService: CommentService) { }

  @Post('tickets/:ticketId')
  @UseInterceptors(FilesInterceptor('files', 10, multerOptions))
  async create(
    @Param('ticketId') ticketId: string,
    @Body() body: { userId: string; content: string; isInternal: string },
    @UploadedFiles() files: Express.Multer.File[]
  ) {

    const createCommentDto: CreateCommentDto = {
      ticketId,
      userId: body.userId,
      content: body.content,
      isInternal: String(body.isInternal) === 'true',
    };

    return await this.commentService.create(createCommentDto, files);
  }

  @Get(':commentId/attachments')
  async listAttachments(@Param('commentId', ParseUUIDPipe) commentId: string) {
    return await this.commentService.getAttachments(commentId);
  }

  @Get(':commentId/attachments/download')
  async downloadFiles(
    @Param('commentId', ParseUUIDPipe) commentId: string,
    @Res({ passthrough: true }) res: Response
  ) {
    const comment = await this.commentService.findOne(commentId);
    const attachments = comment.comment_attachments;

    if (!attachments || attachments.length === 0) {
      throw new HttpException('No attachments found for this comment',
        HttpStatus.NOT_FOUND);
    }

    // CASE A: Only one file, return it directly
    if (attachments.length === 1) {
      const file = attachments[0];
      const filePath = this.commentService.getFilePath(file);

      if (!fs.existsSync(filePath)) {
        throw new HttpException('File not found on server', HttpStatus.NOT_FOUND);
      }

      // A stream is a sequence of data that is sent in a fragmented way.
      const stream = fs.createReadStream(filePath);

      res.set({
        'Content-Type': file.file_type || 'application/octet-stream',
        'Content-Disposition': `attachment; filename="${encodeURIComponent(file.file_name)}"`,
      });

      return new StreamableFile(stream);
    }
    else {
      // CASE B: Multiple files, create a ZIP and return it
      const archive = archiver('zip', { zlib: { level: 9 } });

      res.set({
        'Content-Type': 'application/zip',
        'Content-Disposition': `attachment; filename="comment_${commentId}_attachments.zip"`,
      });

      archive.pipe(res); // res is the destination stream for the ZIP file

      for (const file of attachments) {
        const filePath = this.commentService.getFilePath(file);
        if (fs.existsSync(filePath)) {
          archive.file(filePath, { name: file.file_name });
        }
      }

      await archive.finalize();

      return;
    }
  }
}
