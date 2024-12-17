module.exports = cds.service.impl( async function (srv) {

    const {EmployeeSet,POs,BusinessPartner} = this.entities;

    this.on('boost',async (req,res)=>{
        try {
            const id = req.params[0];
            console.log("Hey Amigo, Your purchase order with id " + req.params[0].NODE_KEY + " will be boosted");
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT : { '+=' : 5000 }
            }).where(id);
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    this.on('largestOrder',async (req,res)=>{
        try {
            // const tx = cds.tx(req);

            // const result = await tx.read(POs).orderBy({
            //     GROSS_AMOUNT : 'desc'
            // }).limit(1);

            const result = await srv.run(SELECT.from(POs).orderBy({
                GROSS_AMOUNT : 'desc'
            }).limit(1));
            return result;
        } catch (error) {
            return 'Error ' + error.toString();
        }
    });

    this.on('getDefaultData',(req,res)=>{

    })

    this.before(['CREATE','UPDATE'], EmployeeSet,(req)=>{
        const sal = parseInt(req.data.salaryAmount);
        if(sal > 100000){
            req.error(500,'Salary is too high')
        }
    });
    //Not working on preview page works with tester file
    // this.on('READ',BusinessPartner,async req => {
    //     const bps = await cds.tx(req).run(req.query);
    //     bps.forEach( bp=>{
    //         const compname = bp.COMPANY_NAME;
    //         const arr = compname.split(" ");
    //         if(arr.lenght > 1){
    //             bp.COMPINIT = (arr[0].substr(0,1)).concat(arr[1].substr(0,1));
    //         }
    //         else{
    //             bp.COMPINIT = (arr[0].slice(0,2));
    //         }

    //     })
    //     return bps;
    // });

    this.on('READ',EmployeeSet,async req =>{
        // const employees = await srv.run(req.query);
        const emps = await cds.tx(req).run(req.query);
        if (req.data.ID == null){
            emps.forEach(emp => {
                if(emp.bankName == "My Bank of Antioch"){
                    emp.salaryAmount += 20000;
                }
            });
        }
        return emps
    });

}
)