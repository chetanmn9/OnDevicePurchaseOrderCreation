# OnDevicePurchaseOrderCreation

On Device Create Purchase Order Demo | Add Items To Purchase Order and Upload
------------ | -------------
![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/Demo_Create_Purchase_Order.gif) | ![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/Demo_Add_Item_To_PO_Upload.gif)

Add New Items for selection in Purchase Order | Add New Supplier for selection in Purchase Order
------------ | -------------
![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/Demo_Add_Items.gif) | ![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/Demo_Add_Suppliers.gif)

Purchase Order header uploaded to SQL Database  |
------------ |
![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/PurchaseOrderHeader.png) |

Purchase Order Items uploaded to SQL Database  |
------------ |
![](https://github.com/chetanmn9/OnDevicePurchaseOrderCreation/blob/master/App%20Demo/PurchaseOrderItems.png) |

This App allows users to create purchase orders on their devices.  This app can be used on site where a contractor can generate a purchase order, assign a desired supplier and add the required items. Once the purchase order is created it can be uploaded to a MySQL database for further admin work by other stakeholders.

* Core Data Database is used for storing purchase orders, Items in a purchase order, item pricing and supplier information.
*	Purchase order and items added in purchase order are maintained as two different entities with one-to-many relationship.
*	All purchase orders are displayed as a table view – with PO number, supplier name and PO created date available at a glance.
*	A php script is called to upload the purchase order to the MySQL Database.
*	Once a purchase order is uploaded, user gets a confirmation notification and the upload button is disabled. Upload status is displayed for each PO.
