import UIKit
import BNBSdkApi
import BanubaARCloudSDK

class ARCloudViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var effectView: EffectPlayerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var player = Player()
    private lazy var cameraDevice = CameraDevice(cameraMode: .FrontCameraSession, captureSessionPreset: .hd1280x720)
    private var effectsArray: [AREffect] = []
    
    //MARK: - ARCloud
    
    // Start loading all effect previews from AR Cloud
    private func loadAREffectPreviews() {
        DispatchQueue.main.async {
            ARCloudManager.fetchAREffects(completion: { [weak self] effectsList  in
                guard let self = self else { return }
                self.effectsArray = effectsList
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EffectCollectionViewCell", for: indexPath) as! EffectCollectionViewCell
        let effect = effectsArray[indexPath.item]
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = try? Data(contentsOf: effect.previewImage) else { return }
            DispatchQueue.main.async {
                cell.titleLabel.text = effect.title
                cell.previewImage.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let effectName = effectsArray[indexPath.item].title
        activityIndicator.startAnimating()
        
        ARCloudManager.loadTappedEffect(effectName: effectName) { [weak self] effectUrl in
            guard let self = self else { return }
            // Apply downloaded effect
            _ = self.player.load(effect: effectName)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        effectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 180, height: 180)
    }
    
    @IBAction func closeARCloud(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Camera
extension ARCloudViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAREffectPreviews()
        effectView.layoutIfNeeded()
        player.use(input: Camera(cameraDevice: cameraDevice))
        player.use(outputs: [effectView])
        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        cameraDevice.start()
    }
}
