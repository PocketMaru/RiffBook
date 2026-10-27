import DesignSystem
import SwiftUI

enum AppDesign {
    static let theme = DesignTheme(
        name: "RiffBook Midnight",
        colors: DesignColors(
            canvas: Color("canvas", bundle: .module),
            card: Color("card", bundle: .module),
            inputBackground: Color("inputBackground", bundle: .module),
            separator: Color("separator", bundle: .module),
            border: Color("border", bundle: .module),
            focusRing: Color("focusRing", bundle: .module),

            textPrimary: Color("textPrimary", bundle: .module),
            textSecondary: Color("textSecondary", bundle: .module),
            textDisabled: Color("textDisabled", bundle: .module),
            textPlaceholder: Color("textPlaceholder", bundle: .module),

            actionPrimary: Color("actionPrimary", bundle: .module),
            onActionPrimary: Color("onActionPrimary", bundle: .module),
            actionSecondary: Color("actionSecondary", bundle: .module),
            onActionSecondary: Color("onActionSecondary", bundle: .module),
            disabledBackground: Color("disabledBackground", bundle: .module),
            selectionBackground: Color("selectionBackground", bundle: .module),
            onSelection: Color("onSelection", bundle: .module),

            complete: Color("complete", bundle: .module),
            onComplete: Color("onComplete", bundle: .module),
            completeBackground: Color("completeBackground", bundle: .module),

            warning: Color("warning", bundle: .module),
            onWarning: Color("onWarning", bundle: .module),
            warningBackground: Color("warningBackground", bundle: .module),

            error: Color("error", bundle: .module),
            onError: Color("onError", bundle: .module),
            errorBackground: Color("errorBackground", bundle: .module)
        )
    )
}
