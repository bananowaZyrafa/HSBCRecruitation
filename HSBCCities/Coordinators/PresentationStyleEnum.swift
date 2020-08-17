import Foundation

public enum CoordinatorPresentationStyle {
    case push
    case modal
    case modalFullscreen(createRoot: Bool)
    case root
    case none
}
