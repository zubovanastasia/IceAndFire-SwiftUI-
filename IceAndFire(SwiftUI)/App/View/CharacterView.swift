//
//  CharacterView.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import SwiftUI
import Combine

class CancellableBag {
    var cancellables: Set<AnyCancellable> = []
}

struct CharacterView: View {
    @State var searchText = ""
    @State var isSearching = false
    @ObservedObject var model: IceAndFireViewModel
    @State var currentDate = Date()
    var bag: CancellableBag = .init()
    private let timer = Timer.publish(every: 10, on: .main, in: .common)
        .autoconnect()
        .eraseToAnyPublisher()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.init(uiColor: .gray))
            VStack{
                HStack{
                    HStack{
                        TextField("Search...", text: $searchText)
                        .padding(.leading, 22)}
                    .padding()
                    .background(Color(uiColor: .lightGray))
                    .frame(height: 40)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .onTapGesture(perform: {
                        isSearching = true
                    })
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            
                            if isSearching {
                                Button(action: { searchText = "" }, label: { Image(systemName: "xmark.circle.fill")
                                        .padding(.vertical)
                                })
                                
                            }
                            
                        }.padding(.horizontal, 30)
                            .foregroundColor(.gray)
                        
                    )
                    .transition(.move(edge: .trailing))
                    .animation(.spring(), value: searchText)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                            searchText = ""
                            
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(Color.init(uiColor: .lightGray))
                                .padding(.trailing)
                                .padding(.leading, -19)
                        })
                    }
                }
                
                List {
                    ForEach((model.characters.filter({ "\(String(describing: $0.name))".contains(searchText) || searchText.isEmpty}))) { character in
                        CharacterCell(character: character)
                    }
                    .listRowBackground(Color.init(uiColor: .gray))
                    .navigationBarTitle(Text("Characters"), displayMode: .large)
                }
                .listStyle(.grouped)
            }
            .alert(item: $model.error) { error in
                Alert(title: Text("Error"), message: Text(error.errorDescription ?? ""))
            }
            .onReceive(timer) { date in
                model.lastUpdateTime = date.timeIntervalSince1970
            }
        }
        .onAppear {model.getObject(id: "568")}
    }
}

//    struct CharactersView_Previews: PreviewProvider {
//        static var previews: some View {
//            CharacterView()
//        }
//    }
//}
