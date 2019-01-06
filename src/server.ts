class Test{
    _p:number
    constructor(p:number){
        this._p = p;
    }

    show():void{
        console.log(this._p);
    }
}

new Test(2.0).show();