import Foundation
import BanubaARCloudSDK
import BanubaEffectPlayer

struct ARCloudManager {
    
    // Add your Client Cloud Id instead of empty quotes
    fileprivate static let banubaARCloud = BanubaARCloud(arCloudUrl: banubaArCloudURL)
    
    static func fetchAREffects(completion: @escaping ([AREffectModel]) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            var array: [AREffectModel] = []
            
            banubaARCloud.getAREffects {(effectsArray, _) in
                effectsArray?.forEach({ effect in
                    let effectModel = AREffectModel(
                        title: effect.title,
                        previewUrl: effect.previewImage.absoluteString)
                    array.append(effectModel)
                })
                
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
    }
    
    static func loadTappedEffect(effectName: String, completion: @escaping (URL) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            banubaARCloud.getAREffects {(effectsArray, _) in
                effectsArray?.forEach({ effect in
                    guard effectName != effect.title else {
                        var currentProgress: Double?
                        banubaARCloud.downloadArEffect(effect) {(progress) in
                            currentProgress = progress
                        } completion: {(url, error) in
                            DispatchQueue.main.async {
                                guard currentProgress != 1 else {
                                    completion(url!)
                                    return
                                }
                            }
                        }
                        return
                    }
                })
            }
        }
    }
}
