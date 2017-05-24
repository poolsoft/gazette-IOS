//
//  TutorialViewController.swift
//  gazette
//
//  Created by Alireza Ghias on 2/3/1396 AP.
//  Copyright © 1396 AreaTak. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, TutorialPageViewControllerDelegate {
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var pageControl: UIPageControl!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
			tutorialPageViewController.tutorialDelegate = self
		}
	}
	
	func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
	                                didUpdatePageCount count: Int) {
		pageControl.numberOfPages = count
	}
	
	func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
	                                didUpdatePageIndex index: Int) {
		pageControl.currentPage = index
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(self.nextPage), name: Events.Start, object: nil)
	}
	func nextPage() {
		performSegue(withIdentifier: "SignupSegue", sender: nil)
	}
}
class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	weak var tutorialDelegate: TutorialPageViewControllerDelegate?
	var views = [UIViewController]()
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}
	
	override func viewDidLoad() {
		self.dataSource = self
		self.delegate = self
		let view1 = self.storyboard?.instantiateViewController(withIdentifier: "view1")
		let view2 = self.storyboard?.instantiateViewController(withIdentifier: "view2")
		let view3 = self.storyboard?.instantiateViewController(withIdentifier: "view3")
		let view4 = self.storyboard?.instantiateViewController(withIdentifier: "view4")
		views = [view4!, view3!, view2!, view1!]
		
		tutorialDelegate?.tutorialPageViewController(self, didUpdatePageCount: views.count)
		tutorialDelegate?.tutorialPageViewController(self, didUpdatePageIndex: views.count - 1)
		
		setViewControllers([views.last!], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = views.index(of: viewController) ?? -1
		index += 1
		if index > views.count - 1 {
			return nil
		} else {
			return views[index]
		}
		
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		var index = views.index(of: viewController) ?? -1
		index -= 1
		if index < 0 {
			return nil
		} else {
			return views[index]
		}
	}
	
	
	
	func pageViewController(_ pageViewController: UIPageViewController,
	                        didFinishAnimating finished: Bool,
	                        previousViewControllers: [UIViewController],
	                        transitionCompleted completed: Bool) {
		if let firstViewController = viewControllers?.first,
			let index = views.index(of: firstViewController) {
			tutorialDelegate?.tutorialPageViewController(self,
			                                             didUpdatePageIndex: index)
		}
	}
}

protocol TutorialPageViewControllerDelegate: class {
	
	/**
	Called when the number of pages is updated.
	
	- parameter tutorialPageViewController: the TutorialPageViewController instance
	- parameter count: the total number of pages.
	*/
	func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
	                                didUpdatePageCount count: Int)
	
	/**
	Called when the current index is updated.
	
	- parameter tutorialPageViewController: the TutorialPageViewController instance
	- parameter index: the index of the currently visible page.
	*/
	func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
	                                didUpdatePageIndex index: Int)
	
}
