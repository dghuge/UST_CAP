sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ust/deepak/purchaseorderapp/test/integration/FirstJourney',
		'ust/deepak/purchaseorderapp/test/integration/pages/POsList',
		'ust/deepak/purchaseorderapp/test/integration/pages/POsObjectPage',
		'ust/deepak/purchaseorderapp/test/integration/pages/POItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, POsList, POsObjectPage, POItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ust/deepak/purchaseorderapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOsList: POsList,
					onThePOsObjectPage: POsObjectPage,
					onThePOItemsObjectPage: POItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);