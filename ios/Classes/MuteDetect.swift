//
//  MuteDetect.swift
//  MuteDetect
//
//  Created by DianQK on 26/03/2018.
//  Copyright © 2018 DianQK. All rights reserved.
//
import Foundation
import AudioToolbox

public class MuteDetect: NSObject {

    public static let shared = MuteDetect()

    private var soundID: SystemSoundID = 0

    private static var muteSoundUrl: URL {
        return Bundle(for: MuteDetect.self).url(forResource: "mute", withExtension: "aiff")!
    }

    private override init() {
        super.init()

        self.soundID = 1
        
        let result = AudioServicesCreateSystemSoundID(MuteDetect.muteSoundUrl as CFURL, &self.soundID)
        if result == kAudioServicesNoError {
            let weakSelf = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

            AudioServicesAddSystemSoundCompletion(self.soundID, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue, { soundId, weakSelfPointer in
                guard let weakSelfPointer = weakSelfPointer else { return }
                let weakSelfValue = Unmanaged<MuteDetect>.fromOpaque(weakSelfPointer).takeUnretainedValue()
                guard let startTime = weakSelfValue.startTime else { return }
                let isMute = CACurrentMediaTime() - startTime < 0.1
                weakSelfValue.completions.forEach({ (completion) in
                    completion(isMute)
                })
                weakSelfValue.completions.removeAll()
                weakSelfValue.startTime = nil
            }, weakSelf)

            var yes: UInt32 = 1
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound,
                                     UInt32(MemoryLayout.size(ofValue: self.soundID)),
                                     &self.soundID,
                                     UInt32(MemoryLayout.size(ofValue: yes)),
                                     &yes)
        } else {
            self.soundID = 0
        }
    }

    public typealias MuteDetectCompletion = ((Bool) -> ())

    private var completions: [MuteDetectCompletion] = []

    private var startTime: CFTimeInterval? = nil

    public func detectSound(_ completion: @escaping MuteDetectCompletion) {
        guard soundID != 0 else {
            completion(false)
            return
        }
        self.completions.append(completion)
        if self.startTime == nil {
            self.startTime = CACurrentMediaTime()
            AudioServicesPlaySystemSound(self.soundID)
        }
    }

    deinit {
        if self.soundID != 0 {
            AudioServicesRemoveSystemSoundCompletion(self.soundID)
            AudioServicesDisposeSystemSoundID(self.soundID)
        }
    }

}
