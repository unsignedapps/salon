//
// The MIT License (MIT) - Copyright © 2018 Unsigned Apps Pty Ltd
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

// MARK: Convenience Conditions: UIView

extension ViewStyle.Condition where T: UIView {

    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.horizontalSizeClass` for a matching `UIUserInterfaceSizeClass`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIUserInterfaceSizeClass` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func horizontalSizeClass (equals sizeClass: UIUserInterfaceSizeClass) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.horizontalSizeClass == sizeClass }
    }

    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.verticalSizeClass` for a matching `UIUserInterfaceSizeClass`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIUserInterfaceSizeClass` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func verticalSizeClass (equals sizeClass: UIUserInterfaceSizeClass) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.verticalSizeClass == sizeClass }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.userInterfaceIdiom` for a matching `UIUserInterfaceIdiom`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIUserInterfaceIdiom` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func userInterfaceIdiom (equals idiom: UIUserInterfaceIdiom) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.userInterfaceIdiom == idiom }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.forceTouchCapability` for a matching `UIForceTouchCapability`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIForceTouchCapability` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func forceTouchCapability (equals capability: UIForceTouchCapability) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.forceTouchCapability == capability }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.preferredContentSizeCategory` for a matching `UIContentSizeCategory`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIContentSizeCategory` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func preferredContentSizeCategory (equals category: UIContentSizeCategory) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.preferredContentSizeCategory == category }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.displayGamut` for a matching `UIDisplayGamut`
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIDisplayGamut` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func displayGamut (equals gamut: UIDisplayGamut) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.displayGamut == gamut }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.displayScale` for a matching display scale.
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The display scale to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func displayScale (equals scale: CGFloat) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.displayScale == scale }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.displayScale` for a display scale that is greater
    /// than the specified one.
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The display scale to test against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func displayScale (greaterThan scale: CGFloat) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.displayScale > scale }
    }
    
    /// Creates and returns a `Condition` that checks a UIView's `traitCollection.displayScale` for a display scale that is less
    /// than the specified one.
    ///
    /// The the documentation for `UITraitCollection` for more information.
    ///
    /// - Parameters:
    ///   - equals: The display scale to test against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func displayScale (lessThan scale: CGFloat) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.traitCollection.displayScale < scale }
    }
}


// MARK: - Convenience Conditions: UIControl

extension ViewStyle.Condition where T: UIControl {
    
    /// Creates and returns a `Condition` that checks a UIControl's `state` for a matching `UIControlState`
    ///
    /// The the documentation for `UIControlState` for more information.
    ///
    /// - Parameters:
    ///   - equals: The `UIControlState` to match against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func controlState (equals state: UIControlState) -> ViewStyle.Condition {
        return ViewStyle.Condition { $0.state == state }
    }
}

// MARK: - Convenience Conditions: UICollectionViewCell

extension ViewStyle.Condition where T: UICollectionViewCell {
    
    /// A derived enum that reflects the state of the UICollectionViewCell
    ///
    /// Remember that a cell can be `.selected` AND `.highlighted`. So test for both if you
    /// want both at the same time.
    ///
    public enum UICollectionViewCellState {

        /// Normal State: when `cell.isHighlighted == false && cell.isSelected == false`
        case normal

        /// Selected State: when `cell.isSelected == true`
        case selected

        /// Highlighted State: when `cell.isHighlighted == true`
        case highlighted
    }
    
    /// Creates and returns a `Condition` that checks a UICollectionViewCell's.
    ///
    /// Note that `State` is derived based on `UICollectionViewCell.isSelected` and `UICollectionViewCell.isHighlighted`
    ///
    /// - Parameters:
    ///   - equals: The state to test against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func cellState (equals state: UICollectionViewCellState) -> ViewStyle.Condition {
        return ViewStyle.Condition { cell in
            switch state {
            case .normal:
                return cell.isHighlighted == false && cell.isSelected == false
            case .selected:
                return cell.isSelected == true
            case .highlighted:
                return cell.isHighlighted == true
            }
        }
    }
}

// MARK: - Convenience Conditions: UITableViewCell

extension ViewStyle.Condition where T: UITableViewCell {

    /// A derived enum that reflects the state of the UITableViewCell
    ///
    /// Remember that a cell can be in multiple states at a time (except `.normal`), so test for all the ones
    /// you want to match against.
    ///
    public enum UITableViewCellState {

        /// Normal State: when `cell.isHighlighted == false && cell.isSelected == false && cell.isEditing == false`
        case normal

        /// Editing State: when `cell.isEditing == true`
        case editing

        /// Selected State: when `cell.isSelected == true`
        case selected

        /// Highlighted State: when `cell.isHighlighted == true`
        case highlighted
    }

    /// Creates and returns a `Condition` that checks a UITableViewCell's.
    ///
    /// Note that `State` is derived based on the various `isSelected`, `isHighlighted` and `isEditing` methods
    /// and can be in more than state at a time, so make sure you test for all the ones you want to match.
    ///
    /// - Parameters:
    ///   - equals: The state to test against.
    ///
    /// - Returns: The new Condition.
    ///
    public static func cellState (equals state: UITableViewCellState) -> ViewStyle.Condition {
        return ViewStyle.Condition { cell in
            switch state {
            case .normal:
                return cell.isHighlighted == false && cell.isSelected == false && cell.isEditing == false
            case .editing:
                return cell.isEditing == true
            case .selected:
                return cell.isSelected == true
            case .highlighted:
                return cell.isHighlighted == true
            }
        }
    }
}
