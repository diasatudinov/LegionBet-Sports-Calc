enum Gradients {
    case tabBar, color3Btn, spinBtn, snack, tab, mealCell, snackCell, dietCell
    
    var color: Gradient {
        switch self {
        case .tabBar:
            Gradient(colors: [.tabTop, .tabBottom])
        case .color3Btn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .spinBtn:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .snack:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .tab:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .mealCell:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .snackCell:
            Gradient(colors: [.btn1, .btn2, .btn3])
        case .dietCell:
            Gradient(colors: [.btn1, .btn2, .btn3])
        }
    }