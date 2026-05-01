export class CreateCommentDto {
    ticketId!: string;
    userId!: string;
    content!: string;
    isInternal!: boolean;
}
