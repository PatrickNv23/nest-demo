import { diskStorage } from "multer";
import { extname, join } from "path";
import { randomUUID } from "crypto";

export const multerOptions = {
    storage: diskStorage({
        destination: './uploads/comments',
        filename: (req, file, callback) => {
            const uniqueSuffix = randomUUID();
            const extension = extname(file.originalname);
            callback(null, `${uniqueSuffix}${extension}`);
        },
    }),
    fileFilter: (req, file, callback) => {
        const allowedMimes = [
            'image/jpeg',
            'image/png',
            'image/gif',
            'image/webp',
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'text/plain',
        ];
        if (allowedMimes.includes(file.mimetype)) {
            callback(null, true);
        } else {
            callback(new Error('Invalid file type. Only images, PDFs, Word documents, and text files are allowed.'), false);
        }
    },
    limits: {
        fileSize: 5 * 1024 * 1024, // 5MB
        files: 10
    }
};