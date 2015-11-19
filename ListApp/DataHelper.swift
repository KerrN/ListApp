import Foundation
import CoreData


// Data Helper class to load dummy data

public class DataHelper {
	let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	public func seedDataStore() {
        
        clearData()
		seedLists()
		seedBuyItems()
	}
    
    public func clearData(){
        
        var fetchRequest = NSFetchRequest(entityName: "ShopList")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.executeRequest(deleteRequest)
        } catch _ {
            // TODO: handle the error
        }
        
        fetchRequest = NSFetchRequest(entityName: "BuyItems")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.executeRequest(deleteRequest)
        } catch _ {
            // TODO: handle the error
        }
    }
	
	private func seedLists() {
		let lists = [
			(listname: "Coles", store: "Noranda",category:"Personal"),
			(listname: "Kmart", store: "Malaga",category:"Personal"),
			(listname: "Target", store: "Morley",category:"Personal")
		]
		
		for list in lists {
			let newList = NSEntityDescription.insertNewObjectForEntityForName("ShopList", inManagedObjectContext: context) as! ShopList
			newList.listname = list.listname
			newList.store = list.store
		}
		
		do {
			try context.save()
		} catch _ {
		}
	}

	private func seedBuyItems() {
		
		let listFetchRequest = NSFetchRequest(entityName: "ShopList")
		let allShopLists = (try! context.executeFetchRequest(listFetchRequest)) as! [ShopList]
		
		let colesShopList = allShopLists.filter({ (sl: ShopList) -> Bool in
			return sl.listname == "Coles"
		}).first
		
		let kmartShopList = allShopLists.filter({ (sl: ShopList) -> Bool in
			return sl.listname == "Kmart"
		}).first
		
		
		let targetShopList = allShopLists.filter({ (sl: ShopList) -> Bool in
			return sl.listname == "Target"
		}).first
		
		let buyitems = [
			(itemName: "Fruit", completed: false, shoplist: NSSet(array: [colesShopList!])),
			(itemName: "Choclates", completed: false, shoplist:NSSet(array: [colesShopList!])),
            (itemName: "Choclates", completed: false, shoplist:NSSet(array: [kmartShopList!])),
            (itemName: "Bread", completed: false, shoplist: NSSet(array: [kmartShopList!])),
			(itemName: "Bread", completed: false, shoplist: NSSet(array: [targetShopList!])),
			(itemName: "Milk", completed: false, shoplist: NSSet(array: [targetShopList!]))
		]
		
		for item in buyitems {
			let newItem = NSEntityDescription.insertNewObjectForEntityForName("BuyItems", inManagedObjectContext: context) as! BuyItems
			newItem.itemName = item.itemName
			newItem.completed = item.completed
            newItem.shoplist = item.shoplist
		}
		
		do {
			try context.save()
		} catch _ {
		}
	}
	
	
	public func printAllLists() {
		let shoplistFetchRequest = NSFetchRequest(entityName: "ShopList")
		let primarySortDescriptor = NSSortDescriptor(key: "listname", ascending: true)
		
		shoplistFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allLists = (try! context.executeFetchRequest(shoplistFetchRequest)) as! [ShopList]
		
		for list in allLists {
			print(" \n List Name: \(list.listname) Store: \(list.store)")
            
            for item in list.buyitems!{
                print(">> \(item.itemName)");
            }
		}
	}
	
	public func printAllBuyItems() {
		let buyitemsFetchRequest = NSFetchRequest(entityName: "BuyItems")
		let primarySortDescriptor = NSSortDescriptor(key: "itemName", ascending: true)
		
		buyitemsFetchRequest.sortDescriptors = [primarySortDescriptor]
		
		let allBuyItems = (try! context.executeFetchRequest(buyitemsFetchRequest)) as! [BuyItems]
		
		for item in allBuyItems {
			print("\n Item Name: \(item.shoplist)")
		//	for list in item.shoplist {
		//		print("\n \(list.name)\n")
		//	}
			//print("-------\n", terminator: "")
		}
	}
}