//
//  Common.swift
//  Mandela
//
//  Created by Hariz Shirazi on 2023-02-11.
//

import Foundation
import UIKit

func overwriteFile(newFileData: Data, targetPath: String) -> Bool {
    #if false
        let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].path

        let pathToRealTarget = targetPath
        let targetPath = documentDirectory + targetPath
        let origData = try! Data(contentsOf: URL(fileURLWithPath: pathToRealTarget))
        try! origData.write(to: URL(fileURLWithPath: targetPath))
    #endif

    // open and map original font
    let fd = open(targetPath, O_RDONLY | O_CLOEXEC)
    if fd == -1 {
        print("Could not open target file")
        return false
    }
    defer { close(fd) }
    // check size of font
    let originalFileSize = lseek(fd, 0, SEEK_END)
    guard originalFileSize >= newFileData.count else {
        print("Original file: \(originalFileSize)")
        print("Replacement file: \(newFileData.count)")
        print("File too big!")
        return false
    }
    lseek(fd, 0, SEEK_SET)

    // Map the font we want to overwrite so we can mlock it
    let fileMap = mmap(nil, newFileData.count, PROT_READ, MAP_SHARED, fd, 0)
    if fileMap == MAP_FAILED {
        print("Failed to map")
        return false
    }
    // mlock so the file gets cached in memory
    guard mlock(fileMap, newFileData.count) == 0 else {
        print("Failed to mlock")
        return true
    }

    // for every 16k chunk, rewrite
    print(Date())
    for chunkOff in stride(from: 0, to: newFileData.count, by: 0x4000) {
        print(String(format: "%lx", chunkOff))
        let dataChunk = newFileData[chunkOff..<min(newFileData.count, chunkOff + 0x4000)]
        var overwroteOne = false
        for _ in 0..<2 {
            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                unaligned_copy_switch_race(
                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count
                )
            }
            if overwriteSucceeded {
                overwroteOne = true
                print("Successfully overwrote!")
                break
            }
            print("try again?!")
        }
        guard overwroteOne else {
            print("Failed to overwrite")
            return false
        }
    }
    print(Date())
    print("Successfully overwrote!")
    return true
}

// MARK: - plist editing function (string)

func plistChangeStr(plistPath: String, key: String, value: String) -> Bool {
    let stringsData = try! Data(contentsOf: URL(fileURLWithPath: plistPath))

    let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
    func changeValue(_ dict: [String: Any], _ key: String, _ value: String) -> [String: Any] {
        var newDict = dict
        for (k, v) in dict {
            if k == key {
                newDict[k] = value
            } else if let subDict = v as? [String: Any] {
                newDict[k] = changeValue(subDict, key, value)
            }
        }
        return newDict
    }

    var newPlist = plist
    newPlist = changeValue(newPlist, key, value)

    let newData = try! PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)

    return overwriteFile(newFileData: newData, targetPath: plistPath)
}

// MARK: - plist editing function (integer)

func plistChangeInt(plistPath: String, key: String, value: Int) -> Bool {
    let stringsData = try! Data(contentsOf: URL(fileURLWithPath: plistPath))

    let plist = try! PropertyListSerialization.propertyList(from: stringsData, options: [], format: nil) as! [String: Any]
    func changeValue(_ dict: [String: Any], _ key: String, _ value: Int) -> [String: Any] {
        var newDict = dict
        for (k, v) in dict {
            if k == key {
                newDict[k] = value
            } else if let subDict = v as? [String: Any] {
                newDict[k] = changeValue(subDict, key, value)
            }
        }
        return newDict
    }

    var newPlist = plist
    newPlist = changeValue(newPlist, key, value)

    let newData = try! PropertyListSerialization.data(fromPropertyList: newPlist, format: .binary, options: 0)

    return overwriteFile(newFileData: newData, targetPath: plistPath)
}

// MARK: - Alert with success or failure

func alertStatus(tweakName: String, succeeded: Bool) {
    if succeeded {
        UIApplication.shared.alert(title: "Success!", body: "Successfully applied tweak \"\(tweakName)\"!", withButton: true)
        Haptic.shared.notify(.success)
    } else {
        UIApplication.shared.alert(title: "Failure!", body: "Could not apply tweak \(tweakName)!", withButton: true)
        Haptic.shared.notify(.error)
    }
}

// MARK: - Supervising functions

// MARK: Supervise

func Supervise() -> Bool {
    let data = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+IDxwbGlzdCB2ZXJzaW9uPSIxLjAiPiA8ZGljdD4gPGtleT5BbGxvd1BhaXJpbmc8L2tleT4gPHRydWUvPiA8a2V5PkNsb3VkQ29uZmlndXJhdGlvblVJQ29tcGxldGU8L2tleT4gPHRydWUvPiA8a2V5PkNvbmZpZ3VyYXRpb25Tb3VyY2U8L2tleT4gPGludGVnZXI+MDwvaW50ZWdlcj4gPGtleT5Jc1N1cGVydmlzZWQ8L2tleT4gPHRydWUvPiA8a2V5PlBvc3RTZXR1cFByb2ZpbGVXYXNJbnN0YWxsZWQ8L2tleT4gPHRydWUvPiA8L2RpY3Q+IDwvcGxpc3Q+"
    return overwriteFile(newFileData: try! Data(base64Encoded: data)!, targetPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/CloudConfigurationDetails.plist")
}

// MARK: Unsupervise

func Unsupervise() -> Bool {
    let data = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KCTxrZXk+QWxsb3dQYWlyaW5nPC9rZXk+Cgk8dHJ1ZS8+Cgk8a2V5PkNsb3VkQ29uZmlndXJhdGlvblVJQ29tcGxldGU8L2tleT4KCTx0cnVlLz4KCTxrZXk+Q29uZmlndXJhdGlvblNvdXJjZTwva2V5PgoJPGludGVnZXI+MDwvaW50ZWdlcj4KCTxrZXk+SXNTdXBlcnZpc2VkPC9rZXk+Cgk8ZmFsc2UvPgoJPGtleT5Qb3N0U2V0dXBQcm9maWxlV2FzSW5zdGFsbGVkPC9rZXk+Cgk8dHJ1ZS8+CjwvZGljdD4KPC9wbGlzdD4K"
    return overwriteFile(newFileData: try! Data(base64Encoded: data)!, targetPath: "/var/containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles/Library/ConfigurationProfiles/CloudConfigurationDetails.plist")
}

// MARK: - AirPower Sound

func OverwriteCharger() -> Bool {
    let data = "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"
    return overwriteFile(newFileData: Data(base64Encoded: data)!, targetPath: "/System/Library/Audio/UISounds/connect_power.caf")
}

// MARK: - DOOM Licence

func OverwriteLicence() -> Bool {
    let locale = (NSLocale.system as NSLocale).object(forKey: .countryCode) as? String
    let path = "/System/Library/ProductDocuments/SoftwareLicenseAgreements/iOS.bundle/" + (locale ?? "en") + ".lproj/License.html"
    let data = "PCFET0NUWVBFIGh0bWw+CjxodG1sIGxhbmc9ImVuIj4KPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0iVVRGLTgiPgogIDxtZXRhIGh0dHAtZXF1aXY9IlgtVUEtQ29tcGF0aWJsZSIgY29udGVudD0iSUU9ZWRnZSI+CiAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwgaW5pdGlhbC1zY2FsZT0xLjAiPgogIDx0aXRsZT5BIDEwMCUgbGVnaXRpbWF0ZSB3YXJyYW50eTwvdGl0bGU+CiAgPHN0eWxlPgogICAgYm9keSB7CiAgICAgIGJhY2tncm91bmQtY29sb3I6IGJsYWNrOwogICAgICBtYXJnaW46IGF1dG87CiAgICAgIHdpZHRoOiA2NDBweDsKICAgIH0KCiAgICBpZnJhbWUgewogICAgICBib3JkZXI6IG5vbmU7CiAgICB9CiAgPC9zdHlsZT4KPC9oZWFkPgo8Ym9keT4KICA8aWZyYW1lIHNyYz0iaHR0cHM6Ly9kb29tLmJvbWJlcmZpc2guY2EiIHRpdGxlPSJXYWl0IHRoaXMgaXNuJ3QgYSB3YXJyYW50eSEiIHdpZHRoPSI2NDAiIGhlaWdodD0iOTYwIj48L2lmcmFtZT4KPC9ib2R5Pgo8L2h0bWw+"
    return overwriteFile(newFileData: try! Data(base64Encoded: data)!, targetPath: path)
}

// MARK: - Respring

func xpc_crash(_ serviceName: String) {
    let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: serviceName.utf8.count)
    defer { buffer.deallocate() }
    strcpy(buffer, serviceName)
    xpc_crasher(buffer)
}

func respring() {
    let processes = [
        "com.apple.cfprefsd.daemon",
        "com.apple.backboard.TouchDeliveryPolicyServer"
    ]
    for process in processes {
        xpc_crash(process)
    }
}
