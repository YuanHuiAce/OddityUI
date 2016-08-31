//
//  CircularButtonBarView.swift
//  Journalism
//
//  Created by Mister on 16/5/16.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import XLPagerTabStrip

public class CircularButtonBarPagerTabStripViewController:ButtonBarPagerTabStripViewController,UICollectionViewDelegateFlowLayout{

    /**
     设置每一个Cell的大小。需要讲高度设置为只能允许一行的高度，否则！！  哼哼 你自己试试吧，，超级刺激的额。
     
     - parameter collectionView:       <#collectionView description#>
     - parameter collectionViewLayout: <#collectionViewLayout description#>
     - parameter indexPath:            <#indexPath description#>
     
     - returns: <#return value description#>
     */
    public override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let childController = viewControllers[indexPath.item] as! IndicatorInfoProvider
        
        let indicatorInfo = childController.indicatorInfoForPagerTabStrip(self)
        
        let size = CGSize(width: 500, height: 200)
        
        let returnSize = NSString(string:indicatorInfo.title).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)], context: nil).size
   
        // 修复当频道调整后出现两行的情况
        return CGSize(width: returnSize.width+(returnSize.width/2), height: collectionView.frame.height-10)
    
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? ButtonBarViewCell else {
            
            return super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        
        cell.label.font = UIFont.a_font3_1
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return 5
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
}

public class CircularButtonBarView: UICollectionView,UIScrollViewDelegate {

    public lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRectMake(0, self.frame.size.height - CGFloat(self.selectedBarHeight), 0, 24))
        bar.layer.zPosition = -10
        bar.layer.cornerRadius = 12
        return bar
        }()
    
    internal var selectedBarHeight: CGFloat = 4 {
        didSet {
            self.updateSlectedBarYPosition()
        }
    }
    var selectedBarAlignment: SelectedBarAlignment = .Center
    var selectedIndex = 0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(selectedBar)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(selectedBar)
    }

    public func moveToIndex(toIndex: Int, animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) {
        selectedIndex = toIndex
        updateSelectedBarPosition(animated, swipeDirection: swipeDirection, pagerScroll: pagerScroll)
    }
    
    public func moveFromIndex(fromIndex: Int, toIndex: Int, progressPercentage: CGFloat,pagerScroll: PagerScroll) {
        selectedIndex = progressPercentage > 0.5 ? toIndex : fromIndex
        
        let fromFrame = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: fromIndex, inSection: 0))!.frame
        let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
        
        var toFrame: CGRect
        
        if toIndex < 0 || toIndex > numberOfItems - 1 {
            if toIndex < 0 {
                let cellAtts = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                toFrame = CGRectOffset(cellAtts!.frame, -cellAtts!.frame.size.width, 0)
            }
            else {
                let cellAtts = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: (numberOfItems - 1), inSection: 0))
                toFrame = CGRectOffset(cellAtts!.frame, cellAtts!.frame.size.width, 0)
            }
        }
        else {
            toFrame = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: toIndex, inSection: 0))!.frame
        }
        
        var targetFrame = fromFrame
        targetFrame.size.height = selectedBar.frame.size.height
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercentage
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercentage
        
        selectedBar.frame = CGRectMake(targetFrame.origin.x, selectedBar.frame.origin.y, targetFrame.size.width, selectedBar.frame.size.height)
        
        var targetContentOffset: CGFloat = 0.0
        if contentSize.width > frame.size.width {
            let toContentOffset = contentOffsetForCell(withFrame: toFrame, andIndex: toIndex)
            let fromContentOffset = contentOffsetForCell(withFrame: fromFrame, andIndex: fromIndex)
            
            targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * progressPercentage)
        }
        
        let animated = abs(contentOffset.x - targetContentOffset) > 30 || (fromIndex == toIndex)
        setContentOffset(CGPointMake(targetContentOffset, 0), animated: animated)
    }
    
    public func updateSelectedBarPosition(animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) -> Void {
        
        var selectedBarFrame = selectedBar.frame
        
        let selectedCellIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        let attributes = layoutAttributesForItemAtIndexPath(selectedCellIndexPath)
        let selectedCellFrame = attributes!.frame
        
        updateContentOffset(animated, pagerScroll: pagerScroll, toFrame: selectedCellFrame, toIndex: selectedCellIndexPath.row)
        
        selectedBarFrame.size.width = selectedCellFrame.size.width
        selectedBarFrame.size.height = 24
        selectedBarFrame.origin.x = selectedCellFrame.origin.x
        
        if animated {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                self?.selectedBar.frame = selectedBarFrame
                })
        }
        else {
            selectedBar.frame = selectedBarFrame
        }
    }
    
    // MARK: - Helpers
    
    private func updateContentOffset(animated: Bool, pagerScroll: PagerScroll, toFrame: CGRect, toIndex: Int) -> Void {
        guard pagerScroll != .No || (pagerScroll != .ScrollOnlyIfOutOfScreen && (toFrame.origin.x < contentOffset.x || toFrame.origin.x >= (contentOffset.x + frame.size.width - contentInset.left))) else { return }
        let targetContentOffset = contentSize.width > frame.size.width ? contentOffsetForCell(withFrame: toFrame, andIndex: toIndex) : 0
        setContentOffset(CGPointMake(targetContentOffset, 0), animated: animated)
    }
    
    private func contentOffsetForCell(withFrame cellFrame: CGRect, andIndex index: Int) -> CGFloat {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        var alignmentOffset: CGFloat = 0.0
        
        switch selectedBarAlignment {
        case .Left:
            alignmentOffset = sectionInset.left
        case .Right:
            alignmentOffset = frame.size.width - sectionInset.right - cellFrame.size.width
        case .Center:
            alignmentOffset = (frame.size.width - cellFrame.size.width) * 0.5
        case .Progressive:
            let cellHalfWidth = cellFrame.size.width * 0.5
            let leftAlignmentOffset = sectionInset.left + cellHalfWidth
            let rightAlignmentOffset = frame.size.width - sectionInset.right - cellHalfWidth
            let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
            let progress = index / (numberOfItems - 1)
            alignmentOffset = leftAlignmentOffset + (rightAlignmentOffset - leftAlignmentOffset) * CGFloat(progress) - cellHalfWidth
        }
        
        var contentOffset = cellFrame.origin.x - alignmentOffset
        contentOffset = max(0, contentOffset)
        contentOffset = min(contentSize.width - frame.size.width, contentOffset)
        return contentOffset
    }
    
    private func updateSlectedBarYPosition() {
        var selectedBarFrame = selectedBar.frame
        selectedBarFrame.origin.y = (44-24)/2
        selectedBarFrame.size.height = 24
        selectedBar.frame = selectedBarFrame
    }
}



public class BottomLineButtonBarView: UICollectionView,UIScrollViewDelegate {
    
    public lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRectMake(0, self.frame.size.height - CGFloat(self.selectedBarHeight), 0, CGFloat(self.selectedBarHeight)))
        bar.layer.zPosition = 9999
        return bar
        }()
    
    internal var selectedBarHeight: CGFloat = 1 {
        didSet {
            self.updateSlectedBarYPosition()
        }
    }
    var selectedBarAlignment: SelectedBarAlignment = .Center
    var selectedIndex = 0
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(selectedBar)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(selectedBar)
    }
    
    public func moveToIndex(toIndex: Int, animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) {
        selectedIndex = toIndex
        updateSelectedBarPosition(animated, swipeDirection: swipeDirection, pagerScroll: pagerScroll)
    }
    
    public func moveFromIndex(fromIndex: Int, toIndex: Int, progressPercentage: CGFloat,pagerScroll: PagerScroll) {
        selectedIndex = progressPercentage > 0.5 ? toIndex : fromIndex
        
        let fromFrame = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: fromIndex, inSection: 0))!.frame
        let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
        
        var toFrame: CGRect
        
        if toIndex < 0 || toIndex > numberOfItems - 1 {
            if toIndex < 0 {
                let cellAtts = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
                toFrame = CGRectOffset(cellAtts!.frame, -cellAtts!.frame.size.width, 0)
            }
            else {
                let cellAtts = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: (numberOfItems - 1), inSection: 0))
                toFrame = CGRectOffset(cellAtts!.frame, cellAtts!.frame.size.width, 0)
            }
        }
        else {
            toFrame = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: toIndex, inSection: 0))!.frame
        }
        
        var targetFrame = fromFrame
        targetFrame.size.height = selectedBar.frame.size.height
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercentage
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercentage
        
        selectedBar.frame = CGRectMake(targetFrame.origin.x, selectedBar.frame.origin.y, targetFrame.size.width, selectedBar.frame.size.height)
        
        var targetContentOffset: CGFloat = 0.0
        if contentSize.width > frame.size.width {
            let toContentOffset = contentOffsetForCell(withFrame: toFrame, andIndex: toIndex)
            let fromContentOffset = contentOffsetForCell(withFrame: fromFrame, andIndex: fromIndex)
            
            targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * progressPercentage)
        }
        
        let animated = abs(contentOffset.x - targetContentOffset) > 30 || (fromIndex == toIndex)
        setContentOffset(CGPointMake(targetContentOffset, 0), animated: animated)
    }
    
    public func updateSelectedBarPosition(animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) -> Void {
        var selectedBarFrame = selectedBar.frame
        
        let selectedCellIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        let attributes = layoutAttributesForItemAtIndexPath(selectedCellIndexPath)
        let selectedCellFrame = attributes!.frame
        
        updateContentOffset(animated, pagerScroll: pagerScroll, toFrame: selectedCellFrame, toIndex: selectedCellIndexPath.row)
        
        selectedBarFrame.size.width = selectedCellFrame.size.width
        selectedBarFrame.origin.x = selectedCellFrame.origin.x
        
        if animated {
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                self?.selectedBar.frame = selectedBarFrame
                })
        }
        else {
            selectedBar.frame = selectedBarFrame
        }
    }
    
    // MARK: - Helpers
    
    private func updateContentOffset(animated: Bool, pagerScroll: PagerScroll, toFrame: CGRect, toIndex: Int) -> Void {
        guard pagerScroll != .No || (pagerScroll != .ScrollOnlyIfOutOfScreen && (toFrame.origin.x < contentOffset.x || toFrame.origin.x >= (contentOffset.x + frame.size.width - contentInset.left))) else { return }
        let targetContentOffset = contentSize.width > frame.size.width ? contentOffsetForCell(withFrame: toFrame, andIndex: toIndex) : 0
        setContentOffset(CGPointMake(targetContentOffset, 0), animated: animated)
    }
    
    private func contentOffsetForCell(withFrame cellFrame: CGRect, andIndex index: Int) -> CGFloat {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        var alignmentOffset: CGFloat = 0.0
        
        switch selectedBarAlignment {
        case .Left:
            alignmentOffset = sectionInset.left
        case .Right:
            alignmentOffset = frame.size.width - sectionInset.right - cellFrame.size.width
        case .Center:
            alignmentOffset = (frame.size.width - cellFrame.size.width) * 0.5
        case .Progressive:
            let cellHalfWidth = cellFrame.size.width * 0.5
            let leftAlignmentOffset = sectionInset.left + cellHalfWidth
            let rightAlignmentOffset = frame.size.width - sectionInset.right - cellHalfWidth
            let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
            let progress = index / (numberOfItems - 1)
            alignmentOffset = leftAlignmentOffset + (rightAlignmentOffset - leftAlignmentOffset) * CGFloat(progress) - cellHalfWidth
        }
        
        var contentOffset = cellFrame.origin.x - alignmentOffset
        contentOffset = max(0, contentOffset)
        contentOffset = min(contentSize.width - frame.size.width, contentOffset)
        return contentOffset
    }
    
    private func updateSlectedBarYPosition() {
        var selectedBarFrame = selectedBar.frame
        selectedBarFrame.origin.y = frame.size.height - selectedBarHeight
        selectedBarFrame.size.height = selectedBarHeight
        selectedBar.frame = selectedBarFrame
    }

}