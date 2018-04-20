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

/// A convenience protocol that allows you to easily apply ViewStyle's directly to
/// conforming objects such as `UIView` or `CALayer`.
public protocol Styleable {

    associatedtype ViewType: NSObject

    /// This should apply the specified ViewStyle to the receiving item.
    ///
    /// The default implementation of this calls `ViewStyle.apply(to:)`
    ///
    /// - Parameters:
    ///   - style: A single ViewStyle of the same type as the receiver that will be applied to the receiver.
    ///
    func apply (style: ViewStyle<ViewType>)

    /// This should apply the specified ViewStyles to the receiving item.
    ///
    /// The default implementation of this creates a composite ViewStyle calls `ViewStyle.apply(to:)`.
    ///
    /// - Parameters:
    ///   - styles: One or more ViewStyles of the same type as the receiver that will be applied to the receiver.
    ///
    func apply (styles: ViewStyle<ViewType>...)

    /// This should conditionally apply the specified styler closure to the receiver if one or more of the
    /// specified conditions are true.
    ///
    /// The default implementation of this creates a ViewStyle and calls `ViewStyle.apply(to:)`.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    func apply (when conditions: ViewStyle<ViewType>.Condition..., styler: @escaping ViewStyle<ViewType>.Styler)
}

// MARK: Default Implementation

extension Styleable {
    typealias Style = ViewStyle<Self>
    public func apply (style: ViewStyle<Self>) {
        style.apply(to: self)
    }

    public func apply (styles: ViewStyle<Self>...) {
        let style = ViewStyle.compose(styles)
        style.apply(to: self)
    }

    public func apply (when conditions: ViewStyle<Self>.Condition..., styler: @escaping ViewStyle<Self>.Styler) {
        let style = ViewStyle(stylers: [ (conditions: conditions, styler: styler) ])
        style.apply(to: self)
    }
}

// MARK: Styleable Conformance

extension UIView: Styleable {}
extension CALayer: Styleable {}
