//
//  PreferenceManager.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import MASShortcut

/// A convenient global handler to access preferences with subscripts.
let preferences = PreferenceManager.shared

// MARK: - PreferenceManager
final class PreferenceManager {
    static let shared = PreferenceManager()
    private let shortcutManager = ShortcutManager.shared
    let defaults = UserDefaults.standard
    
    private init() {
        registerDefaultPreferences()
    }
    
    private func registerDefaultPreferences() {
        // Convert dictionary of type [PreferenceKey: Any] to [String: Any].
        let defaultValues: [String: Any] = defaultPreferences.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        defaults.register(defaults: defaultValues)
    }
}

// MARK: - Subscripts
extension PreferenceManager {
    subscript(key: PreferenceKey<Any>) -> Any? {
        get { return defaults.object(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<URL>) -> URL {
        get { return defaults.url(forKey: key.rawValue) ?? URL(string: "")!}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[Any]>) -> [Any] {
        get { return defaults.array(forKey: key.rawValue) ?? []}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String: Any]>) -> [String: Any] {
        get { return defaults.dictionary(forKey: key.rawValue) ?? [:] }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<String>) -> String {
        get { return defaults.string(forKey: key.rawValue) ?? ""}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String]>) -> [String] {
        get { return defaults.stringArray(forKey: key.rawValue) ?? []}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Data>) -> Data {
        get { return defaults.data(forKey: key.rawValue) ?? Data()}
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Bool>) -> Bool {
        get { return defaults.bool(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Int>) -> Int {
        get { return defaults.integer(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Float>) -> Float {
        get { return defaults.float(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Double>) -> Double {
        get { return defaults.double(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<MASShortcut>) -> MASShortcut {
        // Read-only because the shortcuts is managed and set by MASShortcut.
        get {
            let data = defaults.data(forKey: key.rawValue)
            let bindingOptions = MASShortcutBinder.shared().bindingOptions!
            let transformer = bindingOptions[NSValueTransformerBindingOption] as! ValueTransformer
            return transformer.transformedValue(data) as? MASShortcut ?? MASShortcut()
        }
    }
}

// MARK: - PreferenceKeys
class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}

final class PreferenceKey<T>: PreferenceKeys { }

// MARK: - Preference Keys
extension PreferenceKeys {
    // General
    static let launchAtLogin = PreferenceKey<Bool>("launchAtLogin")
    static let keepWindowsOnTop = PreferenceKey<Bool>("keepWindowsOnTop")
    
    // Shortcuts
    static let uploadImageShortcut = PreferenceKey<MASShortcut>("uploadImageShortcut")
    
    // Hosts
    static let currentHost = PreferenceKey<String>("currentHost")
    static let qiniuHostInfo = PreferenceKey<[String: Any]>("qiniuHostInfo")
}

// MARK: - Default Preference Values
private let defaultPreferences: [PreferenceKeys: Any] = [
    // General
    .launchAtLogin: false,
    .keepWindowsOnTop: true,
    
    // Shortcuts
    .uploadImageShortcut: MASShortcut(key: kVK_ANSI_U, modifiers: [.command, .shift]).data(),
    
    // Hosts
    .currentHost: SupportedHost.qiniu.rawValue,
    .qiniuHostInfo: QiniuHostInfo().dictionary(),
]