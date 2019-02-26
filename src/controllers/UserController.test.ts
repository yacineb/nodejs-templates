import { UserController } from "./UserController";

describe("UserController tests", () => {
    it("getAll OK", () => {
        const uc = new UserController();
        expect(uc.getAll()).toBe("All Users");
    });

    it("get by id", () => {
        const uc = new UserController();
        expect(uc.getOne(1)).toBe("User#1");
    });

    it("get by id", () => {
        const uc = new UserController();
        expect(uc.put(1, {})).toBe("Updating User#" + 1);
    });
});

