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

import XCTest
@testable import Salon

final class ViewStyleTests: XCTestCase {

    // MARK: Initialisation

    func testShouldInitialiseWithClosure () {
        let style = ViewStyle<UIView> { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertNil(style.stylers.first?.conditions)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    func testShouldInitialiseWithConditionsAndClosure() {
        let style = ViewStyle<UIView>(when: .horizontalSizeClass(equals: .regular)) { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertEqual(style.stylers.first?.conditions?.count, 1)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    func testShouldInitialiseWithMultipleConditionsAndClosure() {
        let style = ViewStyle<UIView>(when: .horizontalSizeClass(equals: .regular), .verticalSizeClass(equals: .compact)) { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertEqual(style.stylers.first?.conditions?.count, 2)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    // MARK: Convenience Initialisers

    func testShouldConvenientlyCreateWithClosure () {
        let style: ViewStyle<UIView> = .style { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertNil(style.stylers.first?.conditions)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    func testShouldConvenientlyCreateWithConditionsAndClosure() {
        let style: ViewStyle<UIView> = .style(when: .horizontalSizeClass(equals: .regular)) { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertEqual(style.stylers.first?.conditions?.count, 1)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    func testShouldConvenientlyCreateWithMultipleConditionsAndClosure() {
        let style: ViewStyle<UIView> = .style(when: .horizontalSizeClass(equals: .regular), .verticalSizeClass(equals: .compact)) { view in
            // do nothing
        }

        XCTAssertEqual(style.stylers.count, 1)
        XCTAssertEqual(style.stylers.first?.conditions?.count, 2)
        XCTAssertNotNil(style.stylers.first?.styler)
    }

    // MARK: Composition

    func testShouldCreateCompositeViewStyle () {
        let styles = ViewStyle<UIView>.compose(
            .style { view in },
            .style { view in },
            .style { view in }
        )

        XCTAssertEqual(styles.stylers.count, 3)
        XCTAssertNil(styles.stylers[safe: 0]?.conditions)
        XCTAssertNotNil(styles.stylers[safe: 0]?.styler)
        XCTAssertNil(styles.stylers[safe: 1]?.conditions)
        XCTAssertNotNil(styles.stylers[safe: 1]?.styler)
        XCTAssertNil(styles.stylers[safe: 2]?.conditions)
        XCTAssertNotNil(styles.stylers[safe: 2]?.styler)
    }

    func testShouldConvenientlyCreateCompositeViewStyle () {
        let style1 = ViewStyle<UIView> { view in }
        let style2 = ViewStyle<UIView> { view in }
        let styles = style1 + style2

        XCTAssertEqual(styles.stylers.count, 2)
        XCTAssertNil(styles.stylers[safe: 0]?.conditions)
        XCTAssertNotNil(styles.stylers[safe: 0]?.styler)
        XCTAssertNil(styles.stylers[safe: 1]?.conditions)
        XCTAssertNotNil(styles.stylers[safe: 1]?.styler)
    }

    // MARK: Applying

    func testShouldApplyStyle () {
        let view = UIView()
        view.isHidden = true

        let style = ViewStyle<UIView> { view in
            view.isHidden = false
        }
        style.apply(to: view)

        XCTAssertFalse(view.isHidden)
    }

    func testShouldConditionallyApplyStyle () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return true
        }
        let view = UIView()
        view.isHidden = true

        let style = ViewStyle<UIView>(when: condition) { view in
            view.isHidden = false
        }
        style.apply(to: view)

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotConditionallyApplyStyle () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return false
        }
        let view = UIView()
        view.isHidden = true

        let style = ViewStyle<UIView>(when: condition) { view in
            view.isHidden = false
        }
        style.apply(to: view)

        XCTAssertTrue(view.isHidden)
    }
}
