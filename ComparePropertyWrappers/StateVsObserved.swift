//
//  StateVsObserved.swift
//  ComparePropertyWrappers
//
//  Created by Vsevolod Oplachko on 14.01.2026.
//

import SwiftUI

struct RandomNumberView: View {
    // в этом представлении randomNumber — это @State.
    // каждый раз при его изменении SwiftUI пересчитывает body.
    
    // в нашем представлении со случайным числом объект состояния является свойством свойством состояния randomNumber
    // каждый раз, когда оно изменяется, представление перерисовывается
    // так как StateVsObserved() содержится внутри тела, каждый раз, когда свойство состояния randomNumber изменяется, оно полностью отбрасывает всё, включая модель представления и пересоздает ViewModel, и сбрасывает всё
    // разница между @ObservedObject и @StateObject заключается в том, что @StateObject остаются постоянными, и ViewModel не будет удалена и создана заново (поиграться в StateVsObserved, переключаясь между @ObservedObject и @StateObject)
    // при @ObservedObject, делаешь несколько раз Increase Count, потом жмешь gen randomNumber, то сбрасывается счетчик к истокам первоначального состояния viewModel, если в viewModel count = 0, то будет 0, если 5, то 5
    // при @StateObject переменная count сохраняется при gen randomNumber
    // то есть @ObservedObject удаляются вместе с вью и создаются заново вместе с самим вью каждый раз, когда изменяется свойство состояния @State private var randomNumber = 0
    // @StateObject обладает постоянным свойством, поэтому он помнит исходную viewModel и всё, что с ней связано, текущие значения и так далее, и всякий раз, когда изменяется @State private var randomNumber, это не изменяет и не пересоздает нашу viewModel
    // я запринтил инициализацию для большей наглядности: при @StateObject лог покажет один раз при изменении randomNumber, при @ObservedObject лог будет повторяться при каждом изменении randomNumber, так как viewModel пересоздается, вместе с этим каждый раз инициализирует
    @State private var randomNumber = 0
    
    var body: some View {
        VStack {
            VStack {
                Text("randomNumber: \(randomNumber)")
                
                Button("gen randomNumber") {
                    randomNumber = (0...100).randomElement()!
                }
            }
            
            StateVsObserved()
                .padding()
        }
    }
}

struct StateVsObserved: View {
    @StateObject var viewModel = CounterViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("Count: \(viewModel.count)")
                
                Button("Increase Count") {
                    viewModel.increaseCount()
                }
            }
            
            ChildView(viewModel: viewModel)
        }
    }
}

// следующий вопрос - можем ли мы привести пример, когда следует использовать один @StateObject, когда @ObservedObject
// создадим еще одну вьюшечку) она будет действовать как своего рода дочерняя вьюшечка исходной вьюхи

struct ChildView: View {
    @ObservedObject var viewModel = CounterViewModel()
    
    var body: some View {
        VStack {
            Text("2X Count: \(viewModel.count * 2)")
        }
    }
}

// ChildView — дочерняя вью, она НЕ владеет моделью, а лишь наблюдает за ней.
// CounterViewModel создаётся в родительской вью (StateVsObserved) как @StateObject
// это единственный источник правды и владелец жизненного цикла модели.
//
// @ObservedObject здесь означает:
// - модель приходит извне (из родителя)
// - ChildView не создаёт и не хранит её
// - View просто подписывается на изменения (`objectWillChange`)
//
// когда родитель меняет viewModel.count:
// - CounterViewModel отправляет обновление
// - SwiftUI перерисовывает и родителя, и ChildView
// - при этом сама модель НЕ пересоздаётся
//
// именно поэтому в дочерних вью используется @ObservedObject,
// а @StateObject всегда должен появляться только в том месте,
// где модель создаётся впервые


struct StateVsObserved_Previews: PreviewProvider {
    static var previews: some View {
        RandomNumberView()
    }
}
