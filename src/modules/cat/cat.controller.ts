import { Body, Controller, Delete, Get, Header, HttpCode, HttpStatus, Param, Post, Put, Query, Res } from "@nestjs/common";
import { CreateCatDto } from "./dtos/create-cat.dto";
import { UpdateCatDto } from "./dtos/update-cat.dto";
import { CatService } from "./cat.service";
import { Cat } from "./interfaces/cat.interface";

@Controller('cat')
export class CatController {

    constructor(private catsService: CatService) {}

    @Get()
    findAll() : Cat[] {
        return this.catsService.findAll();
    }

    @Get('match/*path')
    @HttpCode(201)
    @Header('Cache-Control', 'no-store')
    matchRoute() : string {
        return 'This action returns a match route';
    }

    @Get(':id')
    @HttpCode(200)
    @Header('Cache-Control', 'no-store')
    findOne(@Param('id') id: string) : Cat | undefined {
        return this.catsService.findOne(id);
    }


    @Post()
    @HttpCode(201)
    async create(@Body() createCatDto: CreateCatDto) {
        this.catsService.create({
            id: Date.now().toString(),
            ...createCatDto
        });
    }

    @Get('query/xd')
    async findWithQueryParams(@Query('age') age: number, @Query('name') name: string) {
        return `This action returns all cats filtered by age: ${age} and name: ${name}`;
    }

    @Put(':id')
    update(@Param('id') id: string, @Body() updateCatDto: UpdateCatDto) {
        return `This action updates a #${id} cat`;
    }

    @Delete(':id')
    remove(@Param('id') id: string, @Res() res: Response) {
        // res.status(HttpStatus.NO_CONTENT).send();
        return `This action removes a #${id} cat`;
    }
}