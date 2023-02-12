//
//  TypeView.swift
//  Mandela
//
//  Created by Hariz Shirazi on 2023-01-14.
//

import SwiftUI

struct TypeView: View {
    let mobilegestalt = "/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist"
    var body: some View {
        VStack {
            if #available(iOS 16, *) {
                // MARK: iPhone 14 Pro Max
                Button{
                    alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 2796))
                }
            label: {
                Image("iphone.gen3").resizable().frame(width: 13, height: 16)
                    .tint(.accentColor)
                    .colorMultiply(.accentColor)
                    .foregroundColor(.accentColor)
                Text("iPhone 14 Pro Max")
            }
            .controlSize(.large)
            .tint(.accentColor)
            .buttonStyle(.bordered)
                
                // MARK: iPhone 14 Pro
                Button{
                    alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 2796))
                } label: {
                    Image("iphone.gen3").resizable().frame(width: 13, height: 16)
                        .tint(.accentColor)
                        .colorMultiply(.accentColor)
                        .foregroundColor(.accentColor)
                    Text("iPhone 14 Pro")
                }
                .controlSize(.large)
                .tint(.accentColor)
                .buttonStyle(.bordered)
            }
            // MARK: iPhone 12/13 Pro
            Button{
                alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 2532))
            }
        label: {
            Image("iphone.gen2").resizable().frame(width: 13, height: 16)
                .tint(.accentColor)
                .colorMultiply(.accentColor)
                .foregroundColor(.accentColor)
            Text("iPhone 12/13 Pro")
        }
        .controlSize(.large)
        .tint(.accentColor)
        .buttonStyle(.bordered)
            // MARK: iPhone XR/11
            Button{
                alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 1792))
            }
        label: {
            Image("iphone.gen2").resizable().frame(width: 13, height: 16)
                .tint(.accentColor)
                .colorMultiply(.accentColor)
                .foregroundColor(.accentColor)
            Text("iPhone XR/11")
        }
        .controlSize(.large)
        .tint(.accentColor)
        .buttonStyle(.bordered)
            
            Button{
                alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 2436))
            }
            // MARK: iPhone X/XS/11 Pro
        label: {
            Image("iphone.gen2").resizable().frame(width: 13, height: 16)
                .tint(.accentColor)
                .colorMultiply(.accentColor)
                .foregroundColor(.accentColor)
            Text("iPhone X/XS/11 Pro")
        }
        .controlSize(.large)
        .tint(.accentColor)
        .buttonStyle(.bordered)
            // MARK: iPhone 8
            Button{
                alertStatus(tweakName: "Device Type", succeeded: plistChangeInt(plistPath: mobilegestalt, key: "ArtworkDeviceSubType", value: 570))
            }
        label: {
            Image("iphone.gen1").resizable().frame(width: 13, height: 16)
                .tint(.accentColor)
                .colorMultiply(.accentColor)
                .foregroundColor(.accentColor)
            Text("iPhone 8")
        }
        .controlSize(.large)
        .tint(.accentColor)
        .buttonStyle(.bordered)
        }
            
        .navigationTitle("Device Type")
        }
    }

struct TypeView_Previews: PreviewProvider {
    static var previews: some View {
        TypeView()
    }
}
