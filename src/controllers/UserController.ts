import { JsonController, Param, Body, Get, Post, Put, Delete } from "routing-controllers";

@JsonController("/api")
export class UserController {
    @Get("/users")
    getAll() {
       return "All Users";
    }

    @Get("/users/:id")
    getOne(@Param("id") id: number) {
       return `User#${id}`;
    }

    @Put("/users/:id")
    put(@Param("id") id: number, @Body() user: any) {
       return `Updating User#${id}`;
    }
}