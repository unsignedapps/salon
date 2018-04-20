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

final class ConditionTests: XCTestCase {

    // MARK: UIView Conditions

    func testShouldApplyHorizontalSizeClassCondition () {
        let view = HorizontallyRegularView()
        view.isHidden = true

        view.apply(when: .horizontalSizeClass(equals: .regular)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotHorizontalApplySizeClassCondition () {
        let view = HorizontallyRegularView()
        view.isHidden = true

        view.apply(when: .horizontalSizeClass(equals: .compact)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyVerticalSizeClassCondition () {
        let view = VerticallyCompactView()
        view.isHidden = true

        view.apply(when: .verticalSizeClass(equals: .compact)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyVerticalSizeClassCondition () {
        let view = VerticallyCompactView()
        view.isHidden = true

        view.apply(when: .verticalSizeClass(equals: .regular)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyUserInterfaceIdiomCondition () {
        let view = TVUserInterfaceView()
        view.isHidden = true

        view.apply(when: .userInterfaceIdiom(equals: .tv)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyUserInterfaceIdiomCondition () {
        let view = TVUserInterfaceView()
        view.isHidden = true

        view.apply(when: .userInterfaceIdiom(equals: .pad)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyForceTouchCondition () {
        let view = ForceTouchableView()
        view.isHidden = true

        view.apply(when: .forceTouchCapability(equals: .available)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyForceTouchCondition () {
        let view = ForceTouchableView()
        view.isHidden = true

        view.apply(when: .forceTouchCapability(equals: .unavailable)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyContentSizeCondition () {
        let view = ExtraLargeView()
        view.isHidden = true

        view.apply(when: .preferredContentSizeCategory(equals: .extraLarge)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyContentSizeCondition () {
        let view = ExtraLargeView()
        view.isHidden = true

        view.apply(when: .preferredContentSizeCategory(equals: .extraExtraLarge)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyDisplayGamutCondition () {
        let view = SRGBView()
        view.isHidden = true

        view.apply(when: .displayGamut(equals: .SRGB)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyDisplayGamutCondition () {
        let view = SRGBView()
        view.isHidden = true

        view.apply(when: .displayGamut(equals: .P3)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyDisplayScaleEqualsCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(equals: 2)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyDisplayScaleEqualsCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(equals: 3)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyDisplayScaleGreaterThanCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(greaterThan: 1)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyDisplayScaleGreaterThanCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(greaterThan: 2)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }

    func testShouldApplyDisplayScaleLessThanCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(lessThan: 3)) { view in
            view.isHidden = false
        }

        XCTAssertFalse(view.isHidden)
    }

    func testShouldNotApplyDisplayScaleLessThanCondition () {
        let view = TwoTimesView()
        view.isHidden = true

        view.apply(when: .displayScale(lessThan: 2)) { view in
            view.isHidden = false
        }

        XCTAssertTrue(view.isHidden)
    }


    // MARK: - UIControl Conditions

    func testShouldApplyControlStateCondition () {
        let control = UIButton()
        control.isSelected = true
        control.isHidden = true

        control.apply(when: .controlState(equals: .selected)) { control in
            control.isHidden = false
        }

        XCTAssertFalse(control.isHidden)
    }

    func testShouldNotApplyControlStateCondition () {
        let control = UIButton()
        control.isHidden = true

        control.apply(when: .controlState(equals: .selected)) { control in
            control.isHidden = false
        }

        XCTAssertTrue(control.isHidden)
    }


    // MARK: - UICollectionViewCell Conditions

    func testShouldApplyCollectionViewCellStateConditionWhenNormal () {
        let cell = UICollectionViewCell()
        cell.isHidden = true

        cell.apply(when: .cellState(equals: .normal)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldApplyCollectionViewCellStateConditionWhenSelected () {
        let cell = UICollectionViewCell()
        cell.isHidden = true
        cell.isSelected = true

        cell.apply(when: .cellState(equals: .selected)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldApplyCollectionViewCellStateConditionWhenHighlighted () {
        let cell = UICollectionViewCell()
        cell.isHidden = true
        cell.isHighlighted = true

        cell.apply(when: .cellState(equals: .highlighted)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldNotApplyCollectionViewCellStateConditionWhenNormal () {
        let cell = UICollectionViewCell()
        cell.isHidden = true

        cell.apply(when: .cellState(equals: .selected)) { cell in
            cell.isHidden = false
        }

        XCTAssertTrue(cell.isHidden)
    }


    // MARK: - UITableViewCell Conditions

    func testShouldApplyTableViewCellStateConditionWhenNormal () {
        let cell = UITableViewCell()
        cell.isHidden = true

        cell.apply(when: .cellState(equals: .normal)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldApplyTableViewCellStateConditionWhenSelected () {
        let cell = UITableViewCell()
        cell.isHidden = true
        cell.isSelected = true

        cell.apply(when: .cellState(equals: .selected)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldApplyTableViewCellStateConditionWhenEditing () {
        let cell = UITableViewCell()
        cell.isHidden = true
        cell.isEditing = true

        cell.apply(when: .cellState(equals: .editing)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldApplyTableViewCellStateConditionWhenHighlighted () {
        let cell = UITableViewCell()
        cell.isHidden = true
        cell.isHighlighted = true

        cell.apply(when: .cellState(equals: .highlighted)) { cell in
            cell.isHidden = false
        }

        XCTAssertFalse(cell.isHidden)
    }

    func testShouldNotApplyTableViewCellStateConditionWhenNormal () {
        let cell = UITableViewCell()
        cell.isHidden = true

        cell.apply(when: .cellState(equals: .selected)) { cell in
            cell.isHidden = false
        }

        XCTAssertTrue(cell.isHidden)
    }}

// MARK: - Testable Views

fileprivate final class HorizontallyRegularView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(horizontalSizeClass: .regular)
    }
}

fileprivate final class VerticallyCompactView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(verticalSizeClass: .compact)
    }
}

fileprivate final class TVUserInterfaceView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(userInterfaceIdiom: .tv)
    }
}

fileprivate final class ForceTouchableView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(forceTouchCapability: .available)
    }
}

fileprivate final class ExtraLargeView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(preferredContentSizeCategory: .extraLarge)
    }
}

fileprivate final class SRGBView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(displayGamut: .SRGB)
    }
}

fileprivate final class TwoTimesView: UIView {
    override var traitCollection: UITraitCollection {
        return UITraitCollection(displayScale: 2)
    }
}
