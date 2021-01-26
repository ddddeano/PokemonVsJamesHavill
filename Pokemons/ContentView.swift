//
//  ContentView.swift
//  Pokemons
//
//  Created by Daniel Watson on 26/01/2021.
//

import SwiftUI

struct SectionView<T: SectionViewProtocol>: View {
    
    @Binding var vM: T
    
    var body: some View {
        VStack {
            Text(vM.name)
            Button(action: {
                vM.isSelected = true
            }) {
                Text("Click")
            }
        }
    }
}


struct ContentView: View {
    
    @StateObject var vM = ContentView.ViewModel()
    
    var body: some View {
        ForEach(vM.sections, id: \.id) { section in
            SectionView(vM: $vM.sections[index])
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var sections: [SectionVm] = [
            .init(type: .battle),
            .init(type: .myPokemon),
            .init(type: .pokepiedia),
            .init(type: .wilderness)
        ]
    }
    
    struct SectionVm: SectionViewProtocol {
    
        var id = UUID()
        var type: SectionType
        var name: String {
            type.rawValue
        }
        var tools: [Tool]
        var isSelected: Bool = false
        
        init(type: SectionType) {
            self.type = type
            switch type {
            case .battle:
                self.tools = BattleTools.allCases.map {$0.toTool}
            case .myPokemon:
                self.tools = MyPokemonTools.allCases.map {$0.toTool}
            case .pokepiedia:
                self.tools = PokepiedieTools.allCases.map {$0.toTool}
            case .wilderness:
                self.tools = WildernessTools.allCases.map {$0.toTool}
            }
        }
    }
}

protocol SectionViewProtocol {
    var tools: [Tool] { get }
    var name: String { get }
    var isSelected: Bool { get set }
}

protocol ToolsProtocol {
    var toTool: Tool { get }
}

enum SectionType : String, CaseIterable {
    case pokepiedia = "Pokepiedia"
    case wilderness = "The Wilderness"
    case myPokemon = "My Pokemon"
    case battle = "Battle"
}

struct Tool {
    var isSelected: Bool
    var name: String
}

enum PokepiedieTools: String, CaseIterable, ToolsProtocol {
    case magnifyingGlass
    case bookMark
    case pencil
    
    var toTool: Tool {
        .init(isSelected: self == .bookMark, name: rawValue.capitalized)
    }
}

enum WildernessTools: String, CaseIterable, ToolsProtocol {
    case pokeballs
    case rifle
    case binoculars
    
    var toTool: Tool {
        .init(isSelected: self == .pokeballs, name: rawValue.capitalized)
    }
}

enum MyPokemonTools: String, CaseIterable, ToolsProtocol {
    case food
    case water
    case vaccine
    
    var toTool: Tool {
        .init(isSelected: self == .food, name: rawValue.capitalized)
    }
}

enum BattleTools: String, CaseIterable, ToolsProtocol {
    case pokemon
    case mediecine
    case grenades
    
    var toTool: Tool {
        .init(isSelected: self == .pokemon, name: rawValue.capitalized)
    }
}
