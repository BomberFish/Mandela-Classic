//
//  DOOMView.swift
//  Mandela
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import SwiftUI

struct DOOMView: View {
    var body: some View {
        VStack {
            Button{
                alertStatus(tweakName: "DOOM Licence", succeeded: OverwriteLicence())
            }
            label: {
                Image(systemName: "doc.append")
                    .tint(.accentColor)
                    .foregroundColor(.accentColor)
                Text("Enable")
            }
            .controlSize(.large)
            .tint(.accentColor)
            .buttonStyle(.bordered)
        }
        Text("DOOM is property of id Software and ZeniMax Media. All rights reserved.")
            .foregroundColor(Color(UIColor.tertiarySystemBackground))
            .font(.system(size: 12, design: .monospaced))
            .frame (maxWidth: .infinity, alignment: .center)
            .padding()
            
            .navigationTitle("DOOM Licence")
    }
}

struct DOOMView_Previews: PreviewProvider {
    static var previews: some View {
        DOOMView()
    }
}
