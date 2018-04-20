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

final class StyleableTests: XCTestCase {

    // MARK: Applying

    func testShouldApplyStyleClosure () {
        let view = UIView()
        view.isHidden = true
        view.apply { $0.isHidden = false }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldApplyMultipleStyleClosures () {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0

        view.apply(styles:
            .style { $0.isHidden = false },
            .style { $0.alpha = 1 }
        )

        XCTAssertFalse(view.isHidden)
        XCTAssertEqual(view.alpha, 1)
    }

    func testShouldConditioanllyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return true
        }

        let view = UIView()
        view.isHidden = true
        view.apply(when: condition) { $0.isHidden = false }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotConditioanllyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return false
        }

        let view = UIView()
        view.isHidden = true
        view.apply(when: condition) { $0.isHidden = false }

        XCTAssertTrue(view.isHidden)
    }
}
