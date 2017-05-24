import UIKit
import XLActionController

open class TweetbotCell: ActionCell {
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		initialize()
	}
	
	func initialize() {
		actionTitleLabel?.font = AppFont.withSize(Dimensions.TextTiny)
		actionTitleLabel?.textColor = .white
		actionTitleLabel?.textAlignment = .center
		backgroundColor = .darkGray
		let backgroundView = UIView()
		backgroundView.backgroundColor = ColorPalette.DarkAccent
		selectedBackgroundView = backgroundView
	}
}

open class TweetbotActionController: ActionController<TweetbotCell, String, UICollectionReusableView, Void, UICollectionReusableView, Void> {
	
	public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		settings.animation.scale = nil
		settings.animation.present.duration = 0.5
		settings.animation.dismiss.duration = 0.5
		settings.behavior.bounces = false
		settings.behavior.useDynamics = false
		collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 44.0, right: 12.0)
		(collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 6.0, right: 0.0)
		
		cellSpec = .nibFile(nibName: "TweetbotCell", bundle: Bundle(for: TweetbotCell.self), height: { _  in 50 })
		
		onConfigureCellForAction = { [weak self] cell, action, indexPath in
			
			cell.setup(action.data, detail: nil, image: nil)
			let actions = self?.sectionForIndex(indexPath.section)?.actions
			let actionsCount = actions!.count
			cell.separatorView?.isHidden = indexPath.item == (self?.collectionView.numberOfItems(inSection: indexPath.section))! - 1
			
			cell.backgroundColor = action.style == .cancel ? ColorPalette.Primary : ColorPalette.Accent
			cell.actionTitleLabel?.textColor = action.style == .cancel ? UIColor.white : ColorPalette.TextGray
			cell.alpha = action.enabled ? 1.0 : 0.5
			
			var corners = UIRectCorner()
			if indexPath.item == 0 {
				corners = [.topLeft, .topRight]
			}
			if indexPath.item == actionsCount - 1 {
				corners = corners.union([.bottomLeft, .bottomRight])
			}
			
			if corners == .allCorners {
				cell.layer.mask = nil
				cell.layer.cornerRadius = 8.0
			} else {
				let borderMask = CAShapeLayer()
				borderMask.frame = cell.bounds
				borderMask.path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 8.0, height: 8.0)).cgPath
				cell.layer.mask = borderMask
			}
		}
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
