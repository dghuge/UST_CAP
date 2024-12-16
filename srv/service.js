module.exports = async (srv)=>{

    srv.on('greetings',(req,res)=>{
        return "Hello! " + req.data.name + req.data.age;
    })


    srv.on('multi',(req,res)=>{
        return req.data.num1 * req.data.num2;
    })
}