//
//  ContactManager.swift
//  LargeLoan
//
//  Created by TRUMP on 2024/12/26.
//

import Contacts

class ContactManager {
    let contactStore = CNContactStore()
    
    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            completion(granted, error)
        }
    }
    
    func fetchContacts() -> [CNContact]? {
        // 首先检查访问权限
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authorizationStatus {
            
        case .authorized:
            return fetchAllContacts()
            
        case .denied, .restricted:
            return nil
            
        case .notDetermined:
            requestAccess { granted, error in
            }
            return nil
            
        case .limited:
            return nil
            
        @unknown default:
            
            return nil
        }
    }
    
    private func fetchAllContacts() -> [CNContact]? {
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        var contacts: [CNContact] = []
        
        do {
            try contactStore.enumerateContacts(with: fetchRequest) { contact, stop in
                contacts.append(contact)
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
        
        return contacts
    }
    
}

