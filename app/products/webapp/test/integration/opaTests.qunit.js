sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'logaligroup/products/test/integration/FirstJourney',
		'logaligroup/products/test/integration/pages/ProductsList',
		'logaligroup/products/test/integration/pages/ProductsObjectPage',
		'logaligroup/products/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('logaligroup/products') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);