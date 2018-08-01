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

    func testShouldConditionallyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return true
        }

        let view = UIView()
        view.isHidden = true
        view.apply(when: condition) { $0.isHidden = false }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotConditionallyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return false
        }

        let view = UIView()
        view.isHidden = true
        view.apply(when: condition) { $0.isHidden = false }

        XCTAssertTrue(view.isHidden)
    }
    
    
    // MARK: - UIView Initialisers
    
    func testShouldInitViewAndApplyStyleClosure () {
        let style = UIView.Style { view in
            view.tag = 98556
        }
        
        let view = UIView(style: style)
        XCTAssertEqual(view.tag, 98556)
    }
    
    func testShouldInitViewAndApplyMultipleStyleClosers () {
        let view = UIView(styles:
            .style { $0.tag = 1235 },
            .style { $0.tag = 98976 }
        )
        
        XCTAssertEqual(view.tag, 98976)
    }

    func testShouldInitViewAndApplyStyleClosureShorthand () {
        let view = UIView() { view in
            view.tag = 98556
        }
        XCTAssertEqual(view.tag, 98556)
    }
    
    func testShouldInitViewAndConditionallyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return true
        }
        
        let view = UIView(when: [condition]) { $0.tag = 9876 }
        XCTAssertEqual(view.tag, 9876)
    }
    
    func testShouldInitViewAndNotConditionallyApplyStyleClosure () {
        let condition = ViewStyle<UIView>.Condition { _ in
            return false
        }
        
        let view = UIView(when: [condition]) { $0.tag = 9876 }
        XCTAssertEqual(view.tag, 0)
    }
    
    
    // MARK: - CALayer Initialisers

    func testShouldInitLayerAndApplyStyleClosure () {
        let style = CALayer.Style { layer in
            layer.name = "Test Layer"
        }
        
        let layer = CALayer(style: style)
        XCTAssertEqual(layer.name, "Test Layer")
    }
    
    func testShouldInitLayerAndApplyMultipleStyleClosers () {
        let layer = CALayer(styles:
            .style { $0.name = "Test1" },
            .style { $0.name = "Test2" }
        )
        
        XCTAssertEqual(layer.name, "Test2")
    }
    
    func testShouldInitLayerAndApplyStyleClosureShorthand () {
        let layer = CALayer() { layer in
            layer.name = "Test Layer"
        }
        XCTAssertEqual(layer.name, "Test Layer")
    }
    
    func testShouldInitLayerAndConditionallyApplyStyleClosure () {
        let condition = ViewStyle<CALayer>.Condition { _ in
            return true
        }
        
        let layer = CALayer(when: [condition]) { $0.name = "Test Layer" }
        XCTAssertEqual(layer.name, "Test Layer")
    }
    
    func testShouldInitLayerAndNotConditionallyApplyStyleClosure () {
        let condition = ViewStyle<CALayer>.Condition { _ in
            return false
        }
        
        let layer = CALayer(when: [condition]) { $0.name = "Test Layer" }
        XCTAssertNil(layer.name)
    }
}
