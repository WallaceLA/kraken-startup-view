import PhoneNumberKit

class PhoneNumberCustomButton: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "BR"
        }
        set {} // exists for backward compatibility
    }
}
