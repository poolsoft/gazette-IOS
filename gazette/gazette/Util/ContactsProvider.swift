//
//  ContactsProvider.swift
//  app
//
//  Created by alireza ghias on 7/10/16.
//  Copyright © 2016 iccima. All rights reserved.
//

import Foundation
import Contacts
class ContactsProvider {
	static let contactStore = CNContactStore()
	static let keysToFetch = [
		CNContactGivenNameKey,
		CNContactFamilyNameKey,
		CNContactEmailAddressesKey,
		CNContactPhoneNumbersKey,
		]
	static func getContacts(_ onFinished: @escaping ([CNContact]) -> Void) {
		contactStore.requestAccess(for: CNEntityType.contacts) { (granted, error) in
			if error == nil && granted {
				
				do {
					var allContainers: [CNContainer] = []
					var contacts: [CNContact]! = []
					allContainers = try contactStore.containers(matching: nil)
					for container in allContainers {
						let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
						contacts.append(contentsOf: try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor]))
					}
					onFinished(contacts)
				} catch {
					
				}
				
			} else {
				print("could not load contacts error = %@", error?._domain)
			}
		}
	}
	static func getContact(_ phoneString: String) -> CNContact? {
		var contactRes: CNContact? = nil
		try! contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])) { (contact, cursor) in
			for number in contact.phoneNumbers {
				if let phone = number.value as? CNPhoneNumber {
					if PhoneUtil.toPlain(phone.stringValue) == phoneString {
						contactRes = contact
					}
				}
			}
		}
		return contactRes
	}
}
