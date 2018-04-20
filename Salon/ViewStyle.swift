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

//
// This is based on a post by Marin Benčević and all credit for the concept should go to him.
//
// https://medium.cobeisfresh.com/composable-type-safe-uiview-styling-with-swift-functions-8be417da947f
//

/// A wrapper for a closure that can be conditionally applied to a `Styleable` item.
public struct ViewStyle <T> {

    // MARK: Properties and Initialisation
	
	/// A Styler is a closure that accepts the item to be styled as its only parameter
    /// and should be used to set the appropriate style-related properties of the item
    public typealias Styler = (T) -> ()

    // An internal set of conditions + styling closure pair
    typealias ConditionalStyler = (conditions: [Condition]?, styler: Styler)
    internal let stylers: [ConditionalStyler]

    /// Initialises an unconditional ViewStyle with a styler closure.
    ///
    /// - Parameters:
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (styler: @escaping Styler) {
        self.init(stylers: [ (conditions: nil, styler: styler) ])
    }

    /// Initialises a conditional ViewStyle that is only applied when any of the conditions match.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    public init (when conditions: Condition..., styler: @escaping Styler) {
        self.init(stylers: [ (conditions: conditions, styler: styler) ])
    }

    init (stylers: [ConditionalStyler]) {
        self.stylers = stylers
    }


    // MARK: ViewStyle Composition

    /// Creates and returns a new composite `ViewStyle` that would apply the provided ViewStyles
    /// in the order given. Each ViewStyle's conditions are still evaluated prior to application.
    ///
    /// - Parameters:
    ///   - styler: An array of ViewStyle values.
    ///
    /// - Returns: A new `ViewStyle` that includes all of the provided ViewStyles.
    ///
    public static func compose (_ stylers: [ViewStyle<T>]) -> ViewStyle<T> {
        return self.init(stylers: stylers.flatMap { $0.stylers })
    }

    /// Creates and returns a new composite `ViewStyle` that would apply the provided ViewStyles
    /// in the order given. Each ViewStyle's conditions are still evaluated prior to application.
    ///
    /// - Parameters:
    ///   - styler: One or more ViewStyle values.
    ///
    /// - Returns: A new `ViewStyle` that includes all of the provided ViewStyles.
    ///
    public static func compose (_ stylers: ViewStyle<T>...) -> ViewStyle<T> {
        return self.compose(stylers)
    }


    // MARK: Convenience Methods

    /// Creates and returns an unconditional ViewStyle with the specified styler closure.
    ///
    /// When creating a ViewStyle, you normally have to specify the type directly, e.g. `ViewStyle<UILabel>`.
    /// This static function exists so that if the type can be inferred, you don't have to repeat the
    /// full type decleration.
    ///
    /// - Parameters:
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    /// - Returns: The newly created ViewStyle with the specified styler closure.
    ///
    public static func style (styler: @escaping Styler) -> ViewStyle<T> {
        return self.init(stylers: [ (conditions: nil, styler: styler) ])
    }

    /// Creates and returns a conditional ViewStyle with the specified styler closure.
    ///
    /// When creating a ViewStyle, you normally have to specify the type directly, e.g. `ViewStyle<UILabel>`.
    /// This static function exists so that if the type can be inferred, you don't have to repeat the
    /// full type decleration.
    ///
    /// - Parameters:
    ///   - when: One or more `Condition`s that will be evaluated prior to applying the styler closure.
    ///   - styler: An escaping closure that accepts the item to be styled as
    ///             its only parameter and should be used to set the appropriate
    ///             style-related properties of the item.
    ///
    /// - Returns: The newly created ViewStyle with the specified styler closure.
    ///
    public static func style (when conditions: Condition..., styler: @escaping Styler) -> ViewStyle<T> {
        return self.init(stylers: [ (conditions: conditions, styler: styler) ])
    }

    // MARK: Applying Styles

    /// Applies the receiving `ViewStyle` to the specified view or other Styleable item.
    ///
    /// - Parameters:
    ///   - to: The item that the receiving ViewStyle should be applied to.
    public func apply (to item: T) {
        self.stylers
            .filter { styler in
                guard let conditions = styler.conditions, conditions.count > 0 else { return true }
                return conditions.contains(where: { $0.matches(item: item) == true })
            }
            .forEach { $0.styler(item) }
    }


    // MARK: - Child Type: Condition

    /// A Condition is a struct that at its most basic level is a closure that takes in the item being styled,
    /// and returns a Bool indicating whether the Condition should be applied to it.
    public struct Condition {

        // MARK: Properties and Initialisation

        private let matcher: (T) -> Bool

        /// Initialises the `Condition` with the specified closure.
        ///
        /// - Parameters:
        ///   - matcher: An escaping closure that accepts the item to be styled as its only parameter and returns
        ///              `true` if the `Condition` applies to it, or `false` otherwise.
        ///
        public init (_ matcher: @escaping (T) -> Bool) {
            self.matcher = matcher
        }

        // MARK: Matching

        /// Test the specified `item` to see if the receiving `Condition` applies.
        ///
        /// - Parameters:
        ///   - item: The item to be tested.
        ///
        /// - Returns: `true` if this Condition matches, false otherwise.
        fileprivate func matches (item: T) -> Bool {
            return self.matcher(item)
        }
    }

    // MARK: - Convenience Functions

    /// Convenience operator for composing two `ViewStyle` values.
    ///
    /// The `left` ViewStyle will be applied before the `right` in the resulting composite ViewStyle.
    ///
    /// - Parameters:
    ///   - left: A ViewStyle.
    ///   - right: Another ViewStyle.
    ///
    /// - Returns: A composite ViewStyle that applies the `left` ViewStyle before the `right` ViewStyle.
    ///
    public static func + (left: ViewStyle<T>, right: ViewStyle<T>) -> ViewStyle<T> {
        return ViewStyle.compose(left, right)
    }
}
