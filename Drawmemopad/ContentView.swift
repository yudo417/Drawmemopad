//
//  test9.swift
//  testIos
//
//  Created by 林　一貴 on 2024/12/21.
//

import SwiftUI

struct Line:Identifiable {  //lines

     var startposition: CGPoint = .zero
     var position: [CGPoint] = []
     var penWidth: Int = 1
     var penColor: Color = .black
     let id = UUID()
}
struct ContentView: View {
    @State var step = 0.0
    @State var issheeted : Bool = false
    @State var lines:[Line] = []
    @State var selectedColor : [Color] = [.black,.red,.green,.blue,.purple,.yellow,.pink,.orange]
    @State var preColor :Color = .black
    @State var preWidth :Int = 1

    var body: some View {
        NavigationStack {
            VStack(spacing:20) {
                ZStack{
                    let _ = print(lines.count)
                    Color.white
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    if lines.count == 0{
                                        lines.append(Line(startposition: .zero,position:[]))
                                        lines[0].position.append(value.location)
                                    }else{
                                        lines[lines.count - 1].position.append(value.location)
                                    }
                                }
                            .onEnded{ value in
                                lines.append(Line(startposition:.zero, position:[],penWidth:lines.last?.penWidth ?? 1,penColor:lines.last?.penColor ?? .black))
                                }
                        )
                    ForEach(lines) { line in
                        Path{ path in
                            path.addLines(line.position)
                        }.stroke(line.penColor,lineWidth: CGFloat(line.penWidth))
                    }
                }
                .border(.black)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.bouncy) {
                                let storedLine = lines.last!
                                lines = []
                                lines.append(storedLine)

                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.title2)
                        }

                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button {
                            if lines.count == 0{
                                lines.append(Line(startposition:.zero, position:[]))
                            }
                            issheeted.toggle()
                        } label: {
                            Image(systemName: "wrench.adjustable")
                        }

                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            if lines.count > 1{
                                lines.removeLast(2)
                                lines.append(Line(startposition:.zero, position:[]))
                            }
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                        }
                    }
                }
                .sheet(isPresented: $issheeted) {
                    VStack{
                        Spacer()
                        HStack{
                            Text("色")
                            Picker(selection:$preColor,label:Text("色を選択")){
                                ForEach(selectedColor,id:\.self){
                                    Image(systemName: "paintbrush.fill").tag($0)
                                        .foregroundStyle($0)
                                }
                                Image(systemName: "eraser")
                            }.pickerStyle(.wheel)
                        }
                        HStack{
                            Text("太さ")
                            Picker(selection:$preWidth,label:Text("太さを選択")){
                                ForEach(1...10,id:\.self){ i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        Spacer()

                        Button {
                            lines[lines.count - 1].penColor = preColor
                            lines[lines.count - 1].penWidth = preWidth
                            issheeted.toggle()
                        } label: {
                            Text("閉じる")
//                                .font(.title)
                        }
                    }
                    .padding()
                }
//                HStack(spacing:30) {
//
//
//
//                }
                .font(.system(size: 25))
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
