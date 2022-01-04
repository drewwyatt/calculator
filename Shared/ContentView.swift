import ComposableArchitecture
import SwiftUI

struct Record: Identifiable, Equatable {
  var id: Int
  var inputText: String
  var answerText: String
}

struct State: Equatable {
  var history: [Record] = [Record(id: 0, inputText: "1 + 2", answerText: "3"), Record(id: 1, inputText: "ans * 2", answerText: "6")]
}

enum Action: Equatable {
  case calc
}

struct Environment {}

let counterReducer = Reducer<State, Action, Environment> { state, action, _ in
  switch action {
  case .calc:
    return .none
  }
}

struct CalcButton: Hashable {
  var label: String
}

struct ContentView: View {
  let store: Store<State, Action>
  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  let buttons: [CalcButton] = [
    CalcButton(label: "7"),
    CalcButton(label: "8"),
    CalcButton(label: "9"),
    CalcButton(label: "/"),
    
    CalcButton(label: "4"),
    CalcButton(label: "5"),
    CalcButton(label: "6"),
    CalcButton(label: "*"),
    
    CalcButton(label: "1"),
    CalcButton(label: "2"),
    CalcButton(label: "3"),
    CalcButton(label: "+"),
    
    CalcButton(label: "0"),
    CalcButton(label: "."),
    CalcButton(label: "(-)"),
    CalcButton(label: "-")
  ]
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        List(viewStore.history) {record in
          VStack {
            Text(record.inputText).frame(maxWidth: .infinity, alignment: .leading)
            Text(record.answerText).frame(maxWidth: .infinity, alignment: .trailing)
          }
        }
        LazyVGrid(columns: columns) {
          ForEach(buttons, id: \.self) {button in
            Text(button.label)
          }
        }
      }
    }
  }
}

//struct CounterDemoView: View {
//  let store: Store<CounterState, CounterAction>
//
//  var body: some View {
//    Form {
//      Section(header: Text(readMe)) {
//        ContentView(store: self.store)
//          .buttonStyle(.borderless)
//          .frame(maxWidth: .infinity, maxHeight: .infinity)
//      }
//    }
//    //    .navigationBarTitle("Counter demo")
//  }
//}
//
//struct CounterView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationView {
//      CounterDemoView(
//        store: Store(
//          initialState: CounterState(),
//          reducer: counterReducer,
//          environment: CounterEnvironment()
//        )
//      )
//    }
//  }
//}
