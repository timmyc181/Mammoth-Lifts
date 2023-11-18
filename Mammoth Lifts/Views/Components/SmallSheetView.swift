//

import SwiftUI

struct SmallSheetView<Content>: View where Content: View {
//    @Binding var isPresented: Bool
//    @Binding var item: Item?
    @Binding private var isPresented: Bool
    var safeAreaBottom: CGFloat? = nil
    @ViewBuilder var content: () -> Content
    
    @State private var offset: CGFloat = 0
    @State private var offsetPadding: CGFloat = 0
    
    @State private var underlayOpacity: CGFloat = 0
    
    @State private var title: String? = nil
    @State private var closeMethod: SheetCloseMethod = .dragIndicator
    


//    @Environment(\.navigation) private var navigation
    
    init<Item>(item: Binding<Item?>, safeAreaBottom: CGFloat? = nil, content: @escaping (Item) -> Content) {
//        self._item = item
        self._isPresented = Binding(get: {
            item.wrappedValue != nil
        }, set: { value in
            if !value {
                item.wrappedValue = nil
            }
        })
        self.safeAreaBottom = safeAreaBottom
        self.content = {
            content(item.wrappedValue!)
        }
    }
    
    init<Preference>(preference: Preference?, safeAreaBottom: CGFloat? = nil, close: @escaping (Preference) -> (), content: @escaping (Preference) -> Content) {
//        self._item = item
        self._isPresented = Binding(get: {
            preference != nil
        }, set: { value in
            if !value {
                close(preference!)
            }
        })
        self.safeAreaBottom = safeAreaBottom
        self.content = {
            content(preference!)
        }
    }
    
    init(isPresented: Binding<Bool>, safeAreaBottom: CGFloat? = nil, content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.safeAreaBottom = safeAreaBottom
        self.content = content
    }

//    init(isPresented: Bool, safeAreaBottom: CGFloat? = nil, content: @escaping () -> Content) {
//        self.isPresented = isPresented
//        self.safeAreaBottom = safeAreaBottom
//        self.content = content()
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
                .opacity((isPresented ? 0.5 : 0) * underlayOpacity)
                .onTapGesture {
                    isPresented = false
                }
                .transaction({ transaction in
                    if underlayOpacity == 1.0 {
                        transaction.animation = .smooth(duration: 0.4)
                        
                    }
                })
                .animation(.smooth(duration: 0.1), value: underlayOpacity)
                .animation(.smooth(duration: 0.4), value: isPresented)
                .onChange(of: isPresented) { oldValue, newValue in
                    if newValue {
                        offset = 0
                        offsetPadding = 0
                    }
                }
            //            .animation(.smooth(duration: 0.1)) { view in
            //                view
            //                    .opacity(underlayOpacity)
            //            }
            //            .animation(.smooth(duration: 2)) { view in
            //                view
            //                    .opacity(isPresented ? 1 : 0)
            //            }
            //            .animation(.smooth(duration: 2), value: isPresented)
                .allowsHitTesting(isPresented)
            if isPresented {
                VStack {
                    ZStack {
                        ZStack {
                            HStack {
                                Spacer()
                                CloseSheetButton {
                                    isPresented = false
                                }
                            }
                            //                        Text(title ?? "hello")
                            //                            .customFont()
                            Text(title ?? "")
                                .customFont()
                            
                        }
                        .opacity(closeMethod == .button ? 1 : 0)
                        
                        SheetDragIndicator()
                            .opacity(closeMethod == .dragIndicator ? 1 : 0)
                    }
                    .frame(height: closeMethod == .dragIndicator ? 5 : 30)
                    .padding(closeMethod == .button ? 15 : 0)
                    .padding(.top, closeMethod == .dragIndicator ? 10 : 0)
                    
                    //                switch closeMethod {
                    //                case .button:
                    //
                    //                case .dragIndicator:
                    //
                    ////                        .transition(.move(edge: .bottom))
                    //
                    //                }
                    
                    
                    content()
                        .padding(.vertical)
                    
                        .safeAreaPadding(.horizontal, Constants.sheetPadding)
                        .safeAreaPadding(.bottom, safeAreaBottom ?? 0)
                    
                }
                .padding(.bottom, offsetPadding)
                
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(.smallSheetBackground))
                        .ignoresSafeArea()
                }
                
                
                .sheetDragGesture(
                    offset: $offset,
                    padding: $offsetPadding,
                    isPresented: $isPresented,
                    sheetHeight: 250
                )
                .sheetUnderlayOpacity($underlayOpacity)
                
                .offset(y: offset)
                .zIndex(4)
                
                .onChange(of: isPresented) { oldValue, newValue in
                    if newValue {
                        offset = 0
                    }
                }
                .transition(.move(edge: .bottom))
                //            .animation(Constants.sheetPresentationAnimation, value: isPresented)
                
                .onPreferenceChange(SheetTitlePreferenceKey.self) { value in
                    title = value
                    
                }
                .onPreferenceChange(SheetCloseMethodPreferenceKey.self) { value in
                    if let value = value {
                        closeMethod = value
                    }
                    
                }
            }
        }
        .ignoresSafeArea()
            
    }
}

#Preview {
    ContentView()
        .populatedPreviewContainer()
        .background {
            Color.background.ignoresSafeArea()
        }
}

public enum SheetCloseMethod {
    case button, dragIndicator
}


fileprivate struct SheetTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct SheetCloseMethodPreferenceKey: PreferenceKey {
    static var defaultValue: SheetCloseMethod? = nil
    
    static func reduce(value: inout SheetCloseMethod?, nextValue: () -> SheetCloseMethod?) {
        value = nextValue()
    }
}

extension View {
    public func sheetTitle(_ title: String) -> some View {
        preference(key: SheetTitlePreferenceKey.self, value: title)
    }
    
    public func sheetCloseMethod(_ method: SheetCloseMethod) -> some View {
        preference(key: SheetCloseMethodPreferenceKey.self, value: method)
    }

}
