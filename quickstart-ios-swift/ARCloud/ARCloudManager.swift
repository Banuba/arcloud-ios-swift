import Foundation
import BanubaARCloudSDK
import BanubaEffectPlayer

struct ARCloudManager {
    
    // Add your Client Cloud Id instead of empty quotes
    static let arCloudUrl = BNBLicenseManager.create(banubaClientToken)?.getJson().getARCloudUrl()
    fileprivate static let banubaARCloud = BanubaARCloud(arCloudUrl: arCloudUrl!)
    
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

extension String {
    func getARCloudUrl() -> String {
        let data = Data(self.utf8)
        var resultedUrl = String()
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let url = json["ar_cloud_url"] as? String {
                    resultedUrl = url
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return resultedUrl
    }
}
