import Foundation

enum CGMType: String, JSON, CaseIterable, Identifiable {
    var id: String { rawValue }
    case none
    case nightscout
    case xdrip
//    case dexcomG5
//    case dexcomG6
//    case dexcomG7
    case simulator
//    case libreTransmitter
    case glucoseDirect
    case enlite
    case plugin

    var displayName: String {
        switch self {
        case .none:
            return "None"
        case .nightscout:
            return "Nightscout"
        case .xdrip:
            return "xDrip4iOS"
        case .glucoseDirect:
            return "Glucose Direct"
//        case .dexcomG5:
//            return "Dexcom G5"
//        case .dexcomG6:
//            return "Dexcom G6"
//        case .dexcomG7:
//            return "Dexcom G7"
        case .simulator:
            return NSLocalizedString("Glucose Simulator", comment: "Glucose Simulator CGM type")
//        case .libreTransmitter:
//            return NSLocalizedString("Libre Transmitter", comment: "Libre Transmitter type")
        case .enlite:
            return "Medtronic Enlite"
        case .plugin:
            return "plugin CGM"
        }
    }

    var appURL: URL? {
        switch self {
        case .enlite,
             .nightscout,
             .none:
            return nil
        case .xdrip:
            return getXdripURL()
        case .glucoseDirect:
            return URL(string: "libredirect://")!
        case .simulator:
            return nil
        case .plugin:
            return nil
        }
    }

    func getXdripURL() -> URL {
        guard let suiteName = Bundle.main.appGroupSuiteName else {
            print("Could not find app group suite name for CGM type: \(rawValue)")
            return URL(string: "xdripswift://")!
        }

        guard let sharedDefaults = UserDefaults(suiteName: suiteName) else {
            print("Could not initialize shared user defaults for CGM type: \(rawValue)")
            return URL(string: "xdripswift://")!
        }

        let defaultUrl = URL(string: "xdripswift://")!

        if let urlScheme = sharedDefaults.string(forKey: "urlScheme") {
            switch urlScheme {
            case "xdripswiftLeft":
                print("Setting URL scheme: \(urlScheme) for CGM type: \(rawValue)")
                return URL(string: "xdripswiftLeft://") ?? defaultUrl
            case "xdripswiftRight":
                print("Setting URL scheme: \(urlScheme) for CGM type: \(rawValue)")
                return URL(string: "xdripswiftRight://") ?? defaultUrl
            default:
                print("Invalid URL scheme: \(urlScheme) for CGM type: \(rawValue)")
            }
        } else {
            print("URL scheme not found in shared user defaults for CGM type: \(rawValue)")
        }

        return defaultUrl
    }

    var externalLink: URL? {
        switch self {
        case .xdrip:
            return URL(string: "https://github.com/JohanDegraeve/xdripswift")!
        case .glucoseDirect:
            return URL(string: "https://github.com/creepymonster/GlucoseDirectApp")!
        default: return nil
        }
    }

    var subtitle: String {
        switch self {
        case .none:
            return NSLocalizedString("None", comment: "No CGM choiced")
        case .nightscout:
            return NSLocalizedString("Online or internal server", comment: "Online or internal server")
        case .xdrip:
            return NSLocalizedString(
                "Using shared app group with external CGM app xDrip4iOS",
                comment: "Shared app group xDrip4iOS"
            )
//        case .dexcomG5:
//            return NSLocalizedString("Native G5 app", comment: "Native G5 app")
//        case .dexcomG6:
//            return NSLocalizedString("Dexcom G6 app", comment: "Dexcom G6 app")
//        case .dexcomG7:
//            return NSLocalizedString("Dexcom G7 app", comment: "Dexcom G76 app")
        case .simulator:
            return NSLocalizedString("Simple simulator", comment: "Simple simulator")
//        case .libreTransmitter:
//            return NSLocalizedString(
//                "Direct connection with Libre 1 transmitters or European Libre 2 sensors",
//                comment: "Direct connection with Libre 1 transmitters or European Libre 2 sensors"
//            )
        case .glucoseDirect:
            return NSLocalizedString(
                "Using shared app group with external CGM app GlucoseDirect",
                comment: "Shared app group GlucoseDirect"
            )
        case .enlite:
            return NSLocalizedString("Minilink transmitter", comment: "Minilink transmitter")
        case .plugin:
            return NSLocalizedString("Plugin CGM", comment: "Plugin CGM")
        }
    }
}

enum GlucoseDataError: Error {
    case noData
    case unreliableData
}
