Modified Cairngorm Store 
=========================
This is a modified Cairngorm Store based on Cairngorm 2.1 version.
This release include support for mockups - (no flex data services/java)

Modifications made:
===================
**** in package com.adobe.cairngorm.samples.store.business **********************
1. Added class BaseBusinessDelegateMock - this class is a base class for all business delegate mockups.
2. Added classes ProductDelegateMock (for product fetching) and CreditCardDelegateMock (for credit card validation)

**** in package com.adobe.cairngorm.samples.store.command  **********************
3. changed class GetProductsCommand to call ProductDelegateMock
4. changed class ValidateCreditCardCommand to call CreditCardDelegateMock

**** in PaymentInformation.mxml  **************************************************
5. added a visa credit card number to pass basic mx validation :)

Installation Instructions:
==========================
1. Extract ModifiedCairngormStore.zip
2. Open Flex
3. File menu -> Import...
4. Select :"Existing Projects into Workspace"
5. Select the root directory of the extracted project
6. Make sure that the ModifiedCairngormStore project is selected
7. Click Finish button - now you should see the project in your workspace
8. Building the workspace should pass
9. Hit the Run Button - You should see the Cairngorm Store fully functioning :)
