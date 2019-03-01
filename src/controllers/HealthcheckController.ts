import { Controller, Get } from "routing-controllers";

@Controller()
export class HealthcheckController {
    @Get("/_health")
    returnOk() {
       return "OK";
    }
}