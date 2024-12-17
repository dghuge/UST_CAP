using { ust.mycapapp.db.master, ust.mycapapp.db.transaction } from '../db/datamodel';
using { ust.mycapapp.db.CDSViews } from '../db/CDSView';

service  PurchaseService @(path:'PurchaseService', requires: 'authenticated-user') {

    //@readonly
    entity EmployeeSet @(restrict:[
            { grant : ['READ'], to : 'Viewer', where : 'bankName = $user.BankName' },
            { grant : ['WRITE'], to : 'Admin' }
        ]) as projection on master.employees;
    entity BusinessPartner as projection on master.businesspartner;
    entity BusinessAddressSet as projection on master.address;
    entity ProductSet as projection on master.product;
    @Capabilities : { Deletable :false }
    entity POs @(odata.draft.enabled : true) as projection on transaction.purchaseorder
    {
        *,
        Items,
        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'N' then 'New'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
        end as OverallStat : String(10),
        case OVERALL_STATUS
            when 'P' then 2
            when 'N' then 2
            when 'A' then 3
            when 'X' then 1
        end as ColorCode : Integer,
    }
    actions{
        @Common.SideEffects:{
            TargetProperties: [ 'in/GROSS_AMOUNT']
        }
        action boost() returns POs;
    };
    entity POItems as projection on transaction.poitems;
    //entity Products as projection on CDSViews.ProductView;
    //entity Items as projection on CDSViews.ItemView;


    function largestOrder() returns POs;
    function getDefaultData() returns POs;
}