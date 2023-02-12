//
//  AirPowerView.swift
//  Mandela
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import SwiftUI

struct AirPowerView: View {
    var body: some View {
        VStack {
            Button{
                alertStatus(tweakName: "AirPower Charging", succeeded: OverwriteCharger())
            }
            label: {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .tint(.accentColor)
                    .foregroundColor(.accentColor)
                Text("Enable")
            }
            .controlSize(.large)
            .tint(.accentColor)
            .buttonStyle(.bordered)
        }
            .navigationTitle("AirPower Sound")
    }
}

struct AirPowerView_Previews: PreviewProvider {
    static var previews: some View {
        AirPowerView()
    }
}
