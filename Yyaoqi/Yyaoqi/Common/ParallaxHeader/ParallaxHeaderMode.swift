//
//  ParallaxHeaderMode.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import Foundation


public enum ParallaxHeaderMode: Int {
    /**
     The option to scale the content to fill the size of the header. Some portion of the content may be clipped to fill the header’s bounds.
     缩放内容以填充标题的大小的选项。部分内容可能会被裁剪以填充标题的边界。
     */
    case fill = 0
    /**
     The option to center the content aligned at the top in the header's bounds.
     将内容居中对齐的选项。
     */
    case top
    /**
     The option to scale the content to fill the size of the header and aligned at the top in the header's bounds.
     缩放内容以填充标题的大小，并在标题边界的顶部对齐的选项。
     */
    case topFill
    /**
     The option to center the content in the header’s bounds, keeping the proportions the same.
     将内容居中在标题的边界，保持比例相同的选项。
     */
    case center
    /**
     The option to scale the content to fill the size of the header and center the content in the header’s bounds.
     缩放内容以填充标题的大小并将内容居中于标题的边界的选项。
     */
    case centerFill
    /**
     The option to center the content aligned at the bottom in the header’s bounds.
     将内容居中对齐的选项在标题边界的底部。
     */
    case bottom
    /**
     The option to scale the content to fill the size of the header and aligned at the bottom in the header's bounds.
     缩放内容以填充标题的大小，并在标题边界的底部对齐的选项。
     */
    case bottomFill
}
