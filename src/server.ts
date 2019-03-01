import "reflect-metadata"; // this shim is required for types reflection in runtime
import { createExpressServer } from "routing-controllers";

// creates express app, registers all controller routes and returns you express app instance
const app = createExpressServer({
   controllers: [__dirname + "/controllers/*Controller.js"] // import all of the controllers matching this regex
});

// run express application on port 3000
app.listen(3000);