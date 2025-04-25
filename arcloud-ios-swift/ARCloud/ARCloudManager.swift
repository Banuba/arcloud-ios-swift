import Foundation
import BanubaARCloudSDK

struct ARCloudManager {
    
    // Initialize AR Cloud SDK with URL
    static var arcloudEffectsFolderURL: URL {
        let manager = FileManager.default
        let documents = manager.urls(
          for: .documentDirectory,
          in: .userDomainMask
        ).last ?? manager.temporaryDirectory
        let effectsFolder = documents.appendingPathComponent("Effects")
        return effectsFolder
    }
    fileprivate static let banubaARCloud = BanubaARCloud(arCloudUrl: banubaArCloudURL, effectsFolderURL: arcloudEffectsFolderURL)
    fileprivate static var effectsList: [AREffect] = []
    
    static func fetchAREffects(completion: @escaping ([AREffect]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            banubaARCloud.getAREffects {(effectsArray, _) in
                effectsList = effectsArray!
                DispatchQueue.main.async {
                    completion(effectsList)
                }
            }
        }
    }
    
    static func loadTappedEffect(effectName: String, completion: @escaping (URL) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            effectsList.forEach({ effect in
                guard effectName != effect.title else {
                    var currentProgress: Double?
                    if !effect.isDownloaded {
                        banubaARCloud.downloadArEffect(effect) {(progress) in
                            currentProgress = progress
                        } completion: {(url, error) in
                            DispatchQueue.main.async {
                                guard currentProgress != 1 else {
                                    completion(url!)
                                    return
                                }
                            }
                            banubaARCloud.getAREffects { effectsArray, _ in
                                effectsList = effectsArray!
                            }
                        }
                    } else {
                        completion(effect.localURL!)
                    }
                    return
                }
            })
        }
    }
}
