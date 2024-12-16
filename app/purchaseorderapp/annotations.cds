using PurchaseService as service from '../../srv/PurchaseService';

annotate service.POs with @( 

    //Default function not working with readonly can be used on editable fields
    // Common.DefaultValuesFunction : 'getDefaultData',
    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        GROSS_AMOUNT,
        CURRENCY.code,
        OVERALL_STATUS,
    ],

    UI.LineItem:{
        ![@UI.Criticality] : ColorCode,
        $value : [
        {
            $Type: 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'PurchaseService.boost',
            Label: 'Boost',
            Inline: true
        },
        // {
        //     $Type : 'UI.DataField',
        //     Value : OVERALL_STATUS,
        // },
        {
            $Type: 'UI.DataField',
            Value: OverallStat,
            Criticality: ColorCode
        },
    ]},

    UI.HeaderInfo:{

        TypeName : 'Purchase Order',
        TypeNamePlural : 'Purchase Orders',
        Title : { Value : PO_ID },
        Description: { Value: PARTNER_GUID.COMPANY_NAME },
        Initials : { $value: PARTNER_GUID.COMPINIT }
        //ImageUrl: 'https://cdn.pixabay.com/photo/2012/04/13/01/51/hamburger-31775_1280.png'

    },

    UI.Facets : [
        {
            $Type: 'UI.CollectionFacet',
            Label : 'General Information',
            Facets : [
                {
                    $Type: 'UI.ReferenceFacet',
                    Label: 'Order Details',
                    Target:'@UI.Identification'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Pricing',
                    Target : '@UI.FieldGroup#DG'
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'PO Items',
            Target : 'Items/@UI.LineItem',
        },
    ],

    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : PO_ID
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
        },
        // {
        //     $Type : 'UI.DataField',
        //     Label : 'Overall Status',
        //     Value : OverallStat,
        //     Criticality : ColorCode
        // },
    ],

    UI.FieldGroup #DG : {
        Data: [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ]
    }
) ;

annotate service.POItems with @(
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.CATEGORY,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.PRICE,
        },
    ],
    UI.HeaderInfo :{
        TypeName : 'PO Item',
        TypeNamePlural : 'PO Items',
        Title : { Value : PRODUCT_GUID.PRODUCT_ID },
        Description : { Value : PRODUCT_GUID.DESCRIPTION },
        ImageUrl : {$value: PRODUCT_GUID.IMAGEURL,},
    },

    UI.Facets :[
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Item Info',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Details',
                    Target : '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Price',
                    Target : '@UI.FieldGroup#product',
                },
            ],
        },
    ],
    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.CATEGORY,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.SUPPLIER_GUID.COMPANY_NAME,
        },
    ],
    UI.FieldGroup #product: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.PRICE,
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.CURRENCY_CODE,
            },
        ],
    }
);

annotate service.POs with {
    PARTNER_GUID@(
        Common : { 
            Text : PARTNER_GUID.COMPANY_NAME, 
            },
        ValueList.entity : service.BusinessPartner,
    );
    OVERALL_STATUS@(
        readonly,
    )
} ;

annotate service.POItems with {
    PRODUCT_GUID@(
        Common : {
            Text : PRODUCT_GUID.DESCRIPTION,
        },
        ValueList.entity : service.ProductSet
    );
};



@cds.odata.valuelist
annotate service.BusinessPartner with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        }
    ]
);

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        }
    ]
);








