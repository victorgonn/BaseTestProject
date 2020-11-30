//
//  UserDefaultsUtils.swift
//  BaseTestProject
//
//  Created by Victor Goncalves Valfre on 30/11/20.
//

import Foundation

public class UserDefaultsUtils {
    
    public static func saveAccessToken(value: String) {
        let userDef = UserDefaults.standard
        userDef.set(value, forKey: "access-token")
    }
    
    public static func getAccessToken() -> String? {
        let userDef = UserDefaults.standard
        return userDef.string(forKey: "access-token")
    }
    
    public static func saveUid(value: String) {
        let userDef = UserDefaults.standard
        userDef.set(value, forKey: "uid")
    }
    
    public static func getUid() -> String? {
        let userDef = UserDefaults.standard
        return userDef.string(forKey: "uid")
    }
    
    public static func saveClient(value: String) {
        let userDef = UserDefaults.standard
        userDef.set(value, forKey: "client")
    }
    
    public static func getClient() -> String? {
        let userDef = UserDefaults.standard
        return userDef.string(forKey: "client")
    }
}
